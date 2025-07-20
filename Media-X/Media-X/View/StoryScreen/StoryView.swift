//
//  StoryView.swift
//  Media-X
//
//  Created by Moataz Mohamed on 16/07/2025.
//

import SwiftUI
import Kingfisher

struct IdentifiableUUID: Identifiable, Equatable {
    let id: UUID
}

struct StorySheetView:View {
    @StateObject var navigationStateManager = NavigationStateManager(selectionPath: [StoryNavigationPath]())
    @State var isMyStory:Bool = false
    let models: [SBStoryDetails]
    let action:()->()
    var body: some View {
        NavigationStack(path: $navigationStateManager.selectionPath) {
            StoryView(model: models,isMyStory:isMyStory, action: action)
                .navigationDestination(for: StoryNavigationPath.self) { path in
                    switch path {
                    case .profileView(let id) :
                        ProfileView(userId: id)
                    }
                }
                .environmentObject(navigationStateManager)
        }
    }
}

struct StoryView: View {
    
    @EnvironmentObject var navigationStateManager: NavigationStateManager<StoryNavigationPath>
    @StateObject private var viewModel: StoryDetailsViewModel
    @State private var progressWidth : CGFloat = 0
    
    @State private var currentImageId:IdentifiableUUID?
    let model: [SBStoryDetails]
    @State var isMyStory:Bool
    let action:()->()
    init(model: [SBStoryDetails],isMyStory:Bool, action:@escaping ()->()) {
        self.model = model
        let images: [String] = model.flatMap { $0.storyImages.map { $0.urlString } }
        let imagesIds: [UUID] = model.flatMap { $0.storyImages.map { $0.id } }

        let dates: [String] = model.flatMap { storyDetails in
            Array(repeating: storyDetails.story.createdAt ?? "", count: storyDetails.storyImages.count)
        }
        let captions: [String] = model.flatMap { storyDetails in
            Array(repeating: storyDetails.story.text, count: storyDetails.storyImages.count)
        }
        let watchedList : [Bool] = model.flatMap { $0.storyImages.map { $0.isWatched ?? false } }
        _viewModel = StateObject(
            wrappedValue: StoryDetailsViewModel(
                imageCount: model.reduce(into: 0) {
                    $0 += $1.storyImages.count
                },
                images : images,
                dates : dates,
                captions : captions,
                imagesids: imagesIds,
                watchedList: watchedList
            )
        )
        self.isMyStory = isMyStory
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
                            .onTapGesture {
                                navigationStateManager.pushToStage(stage: .profileView(id: user.id.uuidString))
                            }
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
                VStack(spacing:20) {
                    Text(viewModel.captions[viewModel.currentIndex])
                        .customFont(.medium, size: 15)
                        .foregroundStyle(.white)
                    
                    if isMyStory {
                        Button {
                            self.currentImageId = IdentifiableUUID(id: viewModel.imagesIds[viewModel.currentIndex])
                        }label: {
                            Image(systemName: "eye")
                                .customFont(.medium, size: 25)
                                .foregroundStyle(._3_B_9678)
                        }
                    }
                        
                }
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
        .sheet(item: $currentImageId,onDismiss: {
            self.currentImageId = nil
            viewModel.resumeTimer()
        }) { imageId in
            StoryViewersView(imageId:imageId.id) { id in
                navigationStateManager.pushToStage(stage: .profileView(id: id.uuidString))
                currentImageId = nil
            }
            .onAppear{
                viewModel.pauseTimer()
            }
            .presentationDetents([.medium,.large])
            .environmentObject(viewModel)
        }
        .onDisappear {
            viewModel.pauseTimer()
        }
        .onAppear {
            if !viewModel.isPlaying {
                viewModel.resumeTimer()
            }
        }
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
    
    private func markStoryAsWatched() {
        guard let id = manager.getUserId(),
              !watchedList[currentIndex]
        else{return}
        
        let model = SBWatchedStory(
            id: UUID(),
            userId: id,
            storyImageId: imagesIds[currentIndex]
        )
        
        Task {
            do {
                let result = try await manager.uploadWatchModel(model: model)
                switch result {
                case .success(_):
                    print("uploadWatchModel success")
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
                        self.progress += (0.5 / 30)
                    }
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
    
    private func subscribeToCurrentIndex() {
        $currentIndex
            .sink { [weak self] _ in
                self?.markStoryAsWatched()
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
            progress = 0
            currentIndex += 1
        }else {
            endSubject.send(())
        }
    }
    func previousImage() {
        guard currentIndex > 0 else { return }
        progress = 0
        currentIndex -= 1
    }
    
}


struct StoryViewersView:View {
    @EnvironmentObject var viewModel:StoryDetailsViewModel
    @State private var users:[SBUserModel]?
    let imageId:UUID
    let onTapAction:(UUID)->()
    var body: some View {
        VStack {
            Text("Views")
                .customFont(.bold, size: 25)
                .foregroundStyle(.black)
                .padding([.top,.horizontal])
            Spacer()
            if let users = users {
                ScrollView(showsIndicators: false) {
                    VStack {
                        ForEach(users) { user in
                            GeneralUserCellView(width:50,user: user) {} ontapAction: {
                                onTapAction(user.id)
                            }
                            Rectangle()
                                .frame(height: 1)
                                .foregroundStyle(.gray.opacity(0.5))
                                .padding(.horizontal,30)
                        }
                    }
                    .padding(.top)
                }
            }
            
        }
        .task {
            do {
                self.users = try await viewModel.getViewers(imageId: self.imageId)
            }catch {
                print(error.localizedDescription)
            }
        }
    }
}
