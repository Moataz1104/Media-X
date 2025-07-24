//
//  StoryDetailsViewModel.swift
//  Media-X
//
//  Created by Moataz Mohamed on 20/07/2025.
//

import Foundation
import SwiftUI
import Combine

class StoryDetailsViewModel: ObservableObject {
    
    @Published var currentIndex: Int = 0
    @Published var progress:Double = 0
    
    private let manager : StoryWatchable
    
    private let imageCount: Int
    private var cancellables = Set<AnyCancellable>()
    private var timer: AnyCancellable?
    var endSubject: PassthroughSubject<Void, Never> = .init()
    var images: [String]
    var imagesIds: [UUID]
    var dates:[String]
    var captions:[String]
    var watchedList:[Bool]
    var isPlaying : Bool = false
    init(
        imageCount: Int,
        images:[String],
        dates:[String],
        captions:[String],
        imagesids:[UUID],
        watchedList:[Bool]
    ) {
        
        manager = StoryManager()
        self.imageCount = imageCount
        self.images = images
        self.dates = dates
        self.captions = captions
        self.imagesIds = imagesids
        self.watchedList = watchedList
        startTimer()
        subscribeToProgress()
        subscribeToCurrentIndex()
    }
    
    deinit {
        stopTimer()
        print("story deinit")
    }
    
    func getViewers(imageId:UUID) async throws->[SBUserModel]{
        guard let userId = manager.getUserId() else {
            return []
        }
        var data = try await manager.fetchStoryViewers(imageId: imageId)
        data.removeAll(where: {$0.id == userId})
        return data
    }
    
    private func markStoryAsWatched(index:Int) {
        guard let id = manager.getUserId(),
              !watchedList[index]
        else{return}
        
        let model = SBWatchedStory(
            id: UUID(),
            userId: id,
            storyImageId: imagesIds[index]
        )
        
        Task {
            do {
                let result = try await manager.uploadWatchModel(model: model)
                switch result {
                case .success(_):
                    print("uploadWatchModel success")
                    watchedList[index] = true
                case .failure(let failure):
                    print(failure.localizedDescription)
                }
            }catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func startTimer() {
        stopTimer()
        isPlaying = true
        timer = Timer.publish(every: 0.1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else{return}
                if self.progress >= 1 {
                    self.progress = 0
                }else {
                    withAnimation {
                        (self.progress + (0.5 / 30) > 1)  ? (self.progress = 1) : (self.progress += (0.5 / 30))
                    }
                }
            }
    }
    
    private func subscribeToProgress() {
        $progress
            .sink { [weak self] progress in
                if progress == 1 {
                    self?.nextImage()
                }
            }
            .store(in: &cancellables)
    }
    
    private func subscribeToCurrentIndex() {
        $currentIndex
            .sink { [weak self] value in
                self?.markStoryAsWatched(index: value)
            }
            .store(in: &cancellables)
    }
    
    func stopTimer() {
        timer?.cancel()
        timer = nil
        isPlaying = false
    }
    
    func pauseTimer() {
        stopTimer()
        isPlaying = false
    }
    
    func resumeTimer() {
        startTimer()
        isPlaying = true
    }
    
    
    func nextImage() {
        if currentIndex < imageCount - 1 {
            currentIndex += 1
            progress = 0
            startTimer()
        }else {
            endSubject.send(())
        }
    }
    func previousImage() {
        guard currentIndex > 0 else { return }
        currentIndex -= 1
        progress = 0
    }
    
}
