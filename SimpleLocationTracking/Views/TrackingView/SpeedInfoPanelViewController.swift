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
    deinit {
        print("SpeedInfoPanelViewController deinit")
    }
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
            .sink { [weak self] state in
                self?.updateMovePanelButton(state: state)
            }
            .store(in: &subscriptions)

        vm.$isPaused
            .sink { [weak self] isPaused in
                self?.updateStartAndPauseButton(isPaused)
            }.store(in: &subscriptions)

        vm.$totalElapsedTime
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.collectionView.reloadData()
                self?.updateNavigationTitle()
            }.store(in: &subscriptions)

        vm.$unitOfSpeed
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.collectionView.reloadData()
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
        navigationItem.title = vm.totalElapsedTime.hhmmss
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
        vm.startAndPause()
    }

    @objc func stopButtonTapped() {
        vm.stop()
    }

    @objc func movePanel() {
        vm.fpc?.move(to: vm.fpc?.state == .half ? .tip : .half, animated: true)
    }

    func setConstraints() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.verticalEdges.equalTo(view).inset(vm.bottomSafeArea)
            make.horizontalEdges.equalTo(view)
        }
    }

    func configureCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }
}

extension SpeedInfoPanelViewController: UICollectionViewDelegateFlowLayout {

    var bottomPadding: CGFloat {
        vm.bottomSafeArea == 0 ? 10 : 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        ///width: (view.width - (2 *  padding(leading,trailing)) - inter Item padding) / 2
        ///height: (viewHeight (일반 뷰의 0.6배->패널설정) - bottomPadding(safeArea가 0일 때 10) - (2 * bottomSafeArea)) / 2
        ///**collectionView의 위아래로 bottomSafeArea 만큼의 inset이 있음.
        ///이유: 패널이 .tip버전일 때, bottomSafeArea만큼 컬렉션뷰가 노출되기 때문에 보이지 않게 constraints 설정.
        return CGSize(
            width: (collectionView.frame.width - (2 * padding_body_view) - padding_body_body) / 2,
            height: (view.frame.height - 10 - bottomPadding - (2 * vm.bottomSafeArea)) / 2)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: padding_body_view, bottom: 0, right: padding_body_view)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        padding_body_body
    }
}

extension SpeedInfoPanelViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        vm.speedInfos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SpeedInfoPanelViewCell", for: indexPath) as? SpeedInfoPanelViewCell else { return UICollectionViewCell() }
        cell.configure(vm.speedInfos[indexPath.item], unit: vm.unitOfSpeed ?? .kmh)
        return cell
    }
}
