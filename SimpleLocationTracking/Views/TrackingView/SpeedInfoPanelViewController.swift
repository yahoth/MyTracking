//
//  SpeedInfoPanelViewController.swift
//  SimpleLocationTracking
//
//  Created by TAEHYOUNG KIM on 11/7/23.
//

import UIKit
import Combine

import SnapKit
import FloatingPanel


class SpeedInfoPanelViewController: UIViewController {

    //View
    var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .systemBackground
        view.register(SpeedInfoPanelViewCell.self, forCellWithReuseIdentifier: "SpeedInfoPanelViewCell")
        return view
    }()
    var movePanelButtonItem: UIBarButtonItem!
    var startAndPauseButton: UIBarButtonItem!

    var bottomSafeArea: CGFloat {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return 0}
        guard let window = windowScene.windows.first else { return 0}
        guard let root = window.rootViewController else { return 0}
        return root.view.safeAreaInsets.bottom
    }

    //Model
    var vm: TrackingViewModel!
    var subscriptions = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        setConstraints()
        configureCollectionView()
        setupLeftNavigationBarItem()
        setupRightNavigationBarButtonItems()
        updateNavigationTitle()
        bind()
        navigationController?.navigationBar.isTranslucent = false
        view.backgroundColor = .systemBackground
    }

    func bind() {
        vm.$state
            .receive(on: DispatchQueue.main)
            .sink { state in
                self.updateMovePanelButton(state: state)
            }
            .store(in: &subscriptions)

        vm.$isPaused
            .sink { isPaused in
                self.updateStartAndPauseButton(isPaused)
            }.store(in: &subscriptions)

        vm.$totalElapsedTime
            .receive(on: DispatchQueue.main)
            .sink { _ in
                self.collectionView.reloadData()
                self.updateNavigationTitle()
            }.store(in: &subscriptions)
    }

    func setupLeftNavigationBarItem() {
        movePanelButtonItem = UIBarButtonItem(image: UIImage(systemName: "play"), style: .plain, target: self, action: #selector(movePanel))
        navigationItem.leftBarButtonItem = movePanelButtonItem
    }

    func setupRightNavigationBarButtonItems() {
        startAndPauseButton = UIBarButtonItem(title: "StartAndPause", style: .done, target: self, action: #selector(startAndPauseButtonTapped2))

        let stopButton = UIBarButtonItem(image: UIImage(systemName: "stop.fill"), style: .plain, target: self, action: #selector(stopButtonTapped))


        self.navigationItem.rightBarButtonItems = [stopButton, startAndPauseButton]
    }

    func updateNavigationTitle() {
        navigationItem.title = vm.hhmmss
    }

    func updateMovePanelButton(state: FloatingPanelState) {
        let imageName = state == .half ? "chevron.down" : "chevron.up"
        movePanelButtonItem.image = UIImage(systemName: imageName)
    }

    func updateStartAndPauseButton(_ isPaused: Bool) {
        let image = UIImage(systemName: isPaused ? "play.fill" : "pause.fill")
        startAndPauseButton.image = image
    }

    @objc func startAndPauseButtonTapped2() {
        vm.locationManagerDidChangeAuthorization()
    }

    @objc func stopButtonTapped() {
        vm.stop()
    }

    @objc func movePanel() {
        vm.fpc.move(to: vm.fpc.state == .half ? .tip : .half, animated: true)
    }

    func setConstraints() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.verticalEdges.equalTo(view).inset(bottomSafeArea)
            make.horizontalEdges.equalTo(view)
        }
    }

    func configureCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }
}

extension SpeedInfoPanelViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width - 30) / 2, height: (view.safeAreaLayoutGuide.layoutFrame.height * 0.6) - (navigationController?.navigationBar.frame.height ?? 0) - 10 - (bottomSafeArea) / 2)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        10
    }
}

extension SpeedInfoPanelViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        vm.speedInfos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SpeedInfoPanelViewCell", for: indexPath) as? SpeedInfoPanelViewCell else { return UICollectionViewCell() }
        cell.configure(vm.speedInfos[indexPath.item])
        return cell
    }
}
