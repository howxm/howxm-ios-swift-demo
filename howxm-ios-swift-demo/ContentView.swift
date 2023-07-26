import SwiftUI
import Howxm

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundColor(.accentColor)
            Button {
                handleClick()
            } label: {
                HStack {
                    Text("点击弹出")
                            .padding()
                            .frame(maxWidth: .infinity)
                }
            }
        }
                .padding()
    }
}

private func handleClick() {
    Howxm.logLevel = .debug
    
    Howxm.initializeSDK(
            "5ed93d69-7f44-44a7-8769-f8ad131a2010",
            UIApplication.shared.rootViewController!,
            {
                print("initializeSDK completion")

                initCallbacks()

                Howxm.checkOpen("6329d0091a5c789fb97eab345585fded", "uid_001", {
                    print("checkOpen success")
                }, {
                    print("checkOpen failed")
                })

                Howxm.identify(Customer("uid_001", "张三", "zhangsan@howxm.com", "zhangsan@howxm.com", ["age": "18"]), {
                    print("identify success")
                    Howxm.event("payment_click", ["price": 100, "channel": "Swift"], nil, {
                        print("event success")
                    }, { (message: String?) in
                        print("event failed: " + (message ?? ""))
                    })
                }, {
                    print("identify failed")
                })
            }
    )
}

private func initCallbacks() {
    Howxm.onBeforeOpen({ campaignId, uid, extra in
        let message = "OnBeforeOpen:campaignId = \(campaignId),uid = \(uid ?? "未设置"),extra = \(String(describing: extra))"
        print(message)
    })

    Howxm.onOpen({ campaignId, uid, extra in
        let message = "OnOpen:campaignId = \(campaignId),uid = \(uid ?? "未设置"),extra = \(String(describing: extra))"
        print(message)
    })

    Howxm.onClose({ campaignId, uid in
        let message = "OnClose:campaignId= \(campaignId) and uid = \(uid ?? "未设置")"
        print(message)
    })

    Howxm.onComplete({ campaignId, uid in
        let message = "OnComplete:campaignId= \(campaignId) and uid = \(uid ?? "未设置")"
        print(message)
    })

    Howxm.onPageComplete({ campaignId, uid, fieldsEntry in
        let message = "OnPageComplete:campaignId= \(campaignId) and uid = \(uid ?? "未设置") and fieldsEntry = \(String(describing: fieldsEntry))"
        print(message)
    })
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension UIApplication {
    var currentKeyWindow: UIWindow? {
        UIApplication.shared.connectedScenes
                .filter {
                    $0.activationState == .foregroundActive
                }
                .map {
                    $0 as? UIWindowScene
                }
                .compactMap {
                    $0
                }
                .first?.windows
                .filter {
                    $0.isKeyWindow
                }
                .first
    }

    var rootViewController: UIViewController? {
        currentKeyWindow?.rootViewController
    }
}
