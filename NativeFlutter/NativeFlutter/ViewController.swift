//
//  ViewController.swift
//  NativeFlutter
//
//  Created by pc on 2022/11/7.
//

import UIKit
import Flutter
import SnapKit
import Then

// BasicMessageChannel : Flutter与原生相互发送消息，用于数据传递
// EventChannel : 原生发送消息，Flutter接收，用于数据流通信
// MethodChannel : Flutter与原生方法相互调用，用于方法掉用。


class ViewController: UIViewController {
        
    var timer: Timer?
    var second: Int = 0
    var eventSink: FlutterEventSink?
    var eventVC: FlutterViewController?

    
    fileprivate let oneLabel: UILabel = UILabel().then {
        $0.textColor = .black
        $0.backgroundColor = .red.withAlphaComponent(0.3)
        $0.numberOfLines = 0
        $0.font = .systemFont(ofSize: 17, weight: .medium)
    }
    
    fileprivate let twoLabel: UILabel = UILabel().then {
        $0.textColor = .black
        $0.backgroundColor = .red.withAlphaComponent(0.3)
        $0.numberOfLines = 0
        $0.font = .systemFont(ofSize: 17, weight: .medium)
    }
    
    fileprivate let threeLabel: UILabel = UILabel().then {
        $0.textColor = .black
        $0.backgroundColor = .red.withAlphaComponent(0.3)
        $0.numberOfLines = 0
        $0.font = .systemFont(ofSize: 17, weight: .medium)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItemClick(_:)))
        
        setupSubViewsUI()
                
        // Do any additional setup after loading the view.
    }
    
    fileprivate func setupSubViewsUI() -> Void {
        
        view.addSubview(oneLabel)
        view.addSubview(twoLabel)
        view.addSubview(threeLabel)
        
        let btnOne = UIButton()
        btnOne.setTitle("myApp", for: .normal)
        btnOne.setTitleColor(.white, for: .normal)
        btnOne.backgroundColor = .orange
        btnOne.addTarget(self, action: #selector(btnOneClick(_:)), for: .touchUpInside)
        view.addSubview(btnOne)
        
        let btnTwo = UIButton()
        btnTwo.setTitle("BasicMessageChannel", for: .normal)
        btnTwo.setTitleColor(.white, for: .normal)
        btnTwo.backgroundColor = .orange
        btnTwo.addTarget(self, action: #selector(btnTwoClick(_:)), for: .touchUpInside)
        view.addSubview(btnTwo)
        
        let btnThree = UIButton()
        btnThree.setTitle("MethodChannel", for: .normal)
        btnThree.setTitleColor(.white, for: .normal)
        btnThree.backgroundColor = .orange
        btnThree.addTarget(self, action: #selector(btnThreeClick(_:)), for: .touchUpInside)
        view.addSubview(btnThree)
        
        let btnFour = UIButton()
        btnFour.setTitle("EventChannel", for: .normal)
        btnFour.setTitleColor(.white, for: .normal)
        btnFour.backgroundColor = .orange
        btnFour.addTarget(self, action: #selector(btnFourClick(_:)), for: .touchUpInside)
        view.addSubview(btnFour)
        
        oneLabel.snp.makeConstraints { make in
            make.left.equalTo(30)
            make.right.equalTo(-30)
            make.height.equalTo(60)
            make.bottom.equalTo(btnOne.snp.top).offset(-20)
        }
        
        btnOne.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 280, height: 50))
            make.top.equalTo(200)
        }
        
        twoLabel.snp.makeConstraints { make in
            make.left.equalTo(30)
            make.right.equalTo(-30)
            make.height.equalTo(60)
            make.top.equalTo(btnOne.snp.bottom).offset(20)
        }
        
        btnTwo.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 280, height: 50))
            make.top.equalTo(twoLabel.snp.bottom).offset(20)
        }
        
        threeLabel.snp.makeConstraints { make in
            make.left.equalTo(30)
            make.right.equalTo(-30)
            make.height.equalTo(60)
            make.top.equalTo(btnTwo.snp.bottom).offset(20)
        }
        
        btnThree.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 280, height: 50))
            make.top.equalTo(threeLabel.snp.bottom).offset(20)
        }
        
        
        btnFour.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 280, height: 50))
            make.top.equalTo(btnThree.snp.bottom).offset(20)
        }
    }

    
    @objc fileprivate func addItemClick(_ sender: UIBarButtonItem) -> Void {
    }
    
    @objc fileprivate func btnOneClick(_ sender: UIButton) -> Void {
     
        let myAppVC = FlutterViewController(project: nil, initialRoute: "myApp", nibName: nil, bundle: nil)
        self.navigationController?.pushViewController(myAppVC, animated: true)
        
    }
    
    @objc fileprivate func btnTwoClick(_ sender: UIButton) -> Void {
        let basicVC = FlutterViewController(project: nil, initialRoute: "basic", nibName: nil, bundle: nil)
        let basicChannel = FlutterBasicMessageChannel(name: "basic_message_channel", binaryMessenger: basicVC.binaryMessenger)
        self.navigationController?.pushViewController(basicVC, animated: true)
        
        // 接收flutter的消息
        basicChannel.setMessageHandler { message, callBack in
            if let message = message as? [String: String] {
                print("message 字典: \(message)")
                if message.keys.contains("name") {
                    callBack("我是原生的字典!")
                }else if message.keys.contains("key") {
                    callBack("我是原生的数组!")
                }else if message.keys.contains("title") {
                    callBack("我是原生的字符串!")
                }
            }
        }
        
        basicVC.setFlutterViewDidRenderCallback {
            print("~~~~~~~setFlutterViewDidRenderCallback~~~~~`")
            // 发送消息给flutter
            basicChannel.sendMessage("~~我是来自原生的消息~~")
        }
        
    }
    @objc fileprivate func btnThreeClick(_ sender: UIButton) -> Void {
        
        let methodVC = FlutterViewController(project: nil, initialRoute: "method", nibName: nil, bundle: nil)
        
        let methodCChannel = FlutterMethodChannel(name: "method_channel", binaryMessenger: methodVC.binaryMessenger)
        // 接收来自flutter的消息
        methodCChannel.setMethodCallHandler { methodCall, result in
            if methodCall.method == "method_channel_test" {
                if let dic = methodCall.arguments as? [String: String] {
                    print("来自flutter的 参数:\(dic)")
                }
//                methodVC.navigationController?.popViewController(animated: true)
                result("90")
            }
            
        }
        self.navigationController?.pushViewController(methodVC, animated: true)
        
        methodVC.setFlutterViewDidRenderCallback {
            //发送消息给flutter
            methodCChannel.invokeMethod("ios_method", arguments: ["name": "maomao", "level": "20"]) { result in
                if let result = result as? String {
                    print("来自flutter的回调: \(result)")
                }
            }
        }

    }
    
    @objc fileprivate func btnFourClick(_ sender: UIButton) -> Void {
    
        let eventVC = FlutterViewController(project: nil, initialRoute: "event", nibName: nil, bundle: nil)
        let eventChannel = FlutterEventChannel(name: "event_channel", binaryMessenger: eventVC.binaryMessenger)
        eventChannel.setStreamHandler(self)
        self.navigationController?.pushViewController(eventVC, animated: true)
        
        eventVC.setFlutterViewDidRenderCallback {
            self.startTimer()
        }
        self.eventVC = eventVC
        
    }
    
    func startTimer() -> Void {
        if timer == nil {
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { t in
                self.second += 1
                if let eventSink = self.eventSink {
                    print("Timer second: \(self.second) --- eventSink:\(self.eventSink)")
                    eventSink(self.second)
                }
                if self.second >= 60 {
                    t.invalidate()
                }
            })
        }

    }
    
    func endTimer() -> Void {
        second = 0
        timer?.invalidate()
        timer = nil
    }
    
    
    // MARK: 字典转字符串
    func dicValueString(_ dic:[String : Any]) -> String?{
        let data = try? JSONSerialization.data(withJSONObject: dic, options: [])
        let str = String(data: data!, encoding: String.Encoding.utf8)
        return str
    }
    
}


extension ViewController: FlutterStreamHandler {
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        print("onListen arguments: \(arguments) --- events: \(events)")
        self.eventSink = events
        return nil;
    }
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        print("onCancel arguments: \(arguments)")
        self.eventSink = nil
        endTimer()
        eventVC?.popRoute()
        return nil;
    }
}
