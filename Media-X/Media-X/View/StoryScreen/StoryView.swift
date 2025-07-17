//
//  StoryView.swift
//  Media-X
//
//  Created by Moataz Mohamed on 16/07/2025.
//

import SwiftUI
import Kingfisher

struct StoryView: View {
    
    @StateObject private var viewModel: StoryDetailsViewModel
    @State private var progressWidth : CGFloat = 0
    
    let model: [SBStoryDetails]
    let action:()->()
    init(model: [SBStoryDetails], action:@escaping ()->()) {
        self.model = model
        let images: [String] = model.flatMap { $0.storyImages.map { $0.urlString } }

        let dates: [String] = model.flatMap { storyDetails in
            Array(repeating: storyDetails.story.createdAt ?? "", count: storyDetails.storyImages.count)
        }
        let captions: [String] = model.flatMap { storyDetails in
            Array(repeating: storyDetails.story.text, count: storyDetails.storyImages.count)
        }

        _viewModel = StateObject(
            wrappedValue: StoryDetailsViewModel(
                imageCount: model.reduce(into: 0) {
                    $0 += $1.storyImages.count
                },
                images : images,
                dates : dates,
                captions : captions
            )
        )
        self.action = action
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            Color
                .black
//                .opacity(0.5)
            KFImage(URL(string: "\(Constants.SUPABASE_STORAGE_END_POINT)\(viewModel.images[viewModel.currentIndex])"))
                .placeholder({
                    Rectangle()
                        .foregroundStyle(.gray)
                })
                .resizable()
                .scaledToFill()
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                .blur(radius: 30)
            
            KFImage(URL(string: "\(Constants.SUPABASE_STORAGE_END_POINT)\(viewModel.images[viewModel.currentIndex])"))
                .placeholder({
                    Rectangle()
                        .foregroundStyle(.gray)
                })
                .resizable()
                .scaledToFit()
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)


            
            
            
            VStack(spacing:30) {
                
                HStack(spacing:5) {
                    ForEach(0..<viewModel.images.count,id:\.self) { i in
                        progressView(index: i)
                    }
                }
                HStack {
                    if let user = model.first?.user,
                       let url = URL(string: "\(Constants.SUPABASE_STORAGE_END_POINT)\(user.imageId)")
                    {
                        KFImage(url)
                            .placeholder { _ in
                                ProgressView()
                            }
                            .resizable()
                            .scaledToFill()
                            .frame(width: 50,height: 50)
                            .clipShape(.circle)
                     
                        Text(user.name)
                            .customFont(.semiBold, size: 15)
                            .foregroundStyle(.white)
                        
                        Text(HelperFunctions.formatTimeString(from:viewModel.dates[viewModel.currentIndex]))
                            .customFont(.regular, size: 12)
                            .foregroundStyle(.gray)
                    }
                    
                    Spacer()
                    Button {
                        action()
                    }label: {
                        Image(systemName: "xmark")
                            .customFont(.medium, size: 20)
                            .foregroundStyle(._3_B_9678)
                    }
                }
                
                HStack(spacing: 0) {
                    Color.clear
                        .contentShape(Rectangle())
                        .onTapGesture {
                            viewModel.previousImage()
                        }
                    
                    Color.clear
                        .contentShape(Rectangle())
                        .onLongPressGesture(perform: {
                            viewModel.pauseTimer()
                        }, onPressingChanged: { isPressing in
                            if isPressing {
                                viewModel.pauseTimer()
                            }else {
                                viewModel.resumeTimer()
                            }
                        })
                        
                    
                    Color.clear
                        .contentShape(Rectangle())
                        .onTapGesture {
                            viewModel.nextImage()
                        }
                }
                
                Text(viewModel.captions[viewModel.currentIndex])
                    .customFont(.medium, size: 15)
                    .foregroundStyle(.white)
                    .padding(.bottom,80)
                
            }
            .padding(.top,50)
            .padding()
            .background(alignment:.top) {
                LinearGradient(colors: [
                    .black.opacity(0.3),
                    .black.opacity(0.2),
                    .black.opacity(0.1),
                    .black.opacity(0.05),
                    .black.opacity(0.03),
                    .black.opacity(0.01),
                ], startPoint: .top, endPoint: .bottom)
                .frame(height: 200)
            }
        }
        .onReceive(viewModel.endSubject, perform: { _ in
            action()
        })
        .ignoresSafeArea()
    }
    
    
    private func progressView(index:Int) -> some View {
        ZStack(alignment:.leading) {
            
            RoundedRectangle(cornerRadius: 10)
                .foregroundStyle(.white.opacity(0.3))
                .frame(height: 3)
            
            
            
            let finalProgress = index < viewModel.currentIndex ? progressWidth : index > viewModel.currentIndex ? 0 : (min(viewModel.progress * progressWidth, progressWidth))
            RoundedRectangle(cornerRadius: 10)
                .foregroundStyle(.white)
                .frame(width: finalProgress,height: 3)
        }
        .background(
            GeometryReader { geo in
                Color.clear
                    .onAppear {
                        guard self.progressWidth == 0 else{return}
                        progressWidth = geo.size.width
                    }
                    .onChange(of: geo.size.width) { _,newWidth in
                        guard self.progressWidth == 0 else{return}
                        progressWidth = newWidth
                    }
            }
        )
    }
}

import SwiftUI
import Combine

class StoryDetailsViewModel: ObservableObject {
    
    @Published var currentIndex: Int = 0
    @Published var progress:Double = 0
    
    
    private let imageCount: Int
    private var cancellables = Set<AnyCancellable>()
    private var timer: AnyCancellable?
    var endSubject: PassthroughSubject<Void, Never> = .init()
    var images: [String]
    var dates:[String]
    var captions:[String]
    init(imageCount: Int,images:[String],dates:[String],captions:[String]) {
        self.imageCount = imageCount
        self.images = images
        self.dates = dates
        self.captions = captions
        startTimer()
        subscribeToProgress()
    }
    
    deinit {
        stopTimer()
        print("story deinit")
    }
    
    func startTimer() {
        stopTimer()
        timer = Timer.publish(every: 0.1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                withAnimation {
                    self?.progress += (0.1 / 30)
                }
            }
    }
    
    private func subscribeToProgress() {
        $progress
            .sink { [weak self] progress in
                if progress >= 1 {
                    self?.nextImage()
                }
            }
            .store(in: &cancellables)
    }
    
    func stopTimer() {
        timer?.cancel()
        timer = nil
    }
    
    func pauseTimer() {
        stopTimer()
    }
    
    func resumeTimer() {
        startTimer()
    }
    
    
    func nextImage() {
        if currentIndex < imageCount - 1 {
            currentIndex += 1
            progress = 0
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

