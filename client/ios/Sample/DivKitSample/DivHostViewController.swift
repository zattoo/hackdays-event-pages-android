import UIKit

import DivKit
import LayoutKit

final class DivHostViewController: UIViewController {
  private var divHostView: DivHostView!
  private var components: DivKitComponents!

  override func viewDidLoad() {
    super.viewDidLoad()
    components = DivKitComponents(
      updateCardAction: nil,
      urlOpener: { UIApplication.shared.open($0) }
    )
    divHostView = DivHostView(components: components)
    
    if let cards = try? DivJson.loadCards() {
      view.addSubview(divHostView)
      divHostView.setData(cards)
    }
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    divHostView.frame = view.bounds.inset(by: view.safeAreaInsets)
  }
}

extension DivHostViewController: UIActionEventPerforming {
  func perform(uiActionEvent event: UIActionEvent, from sender: AnyObject) {
    switch event.payload {
    case let .divAction(params):
      components.handleActions(params: params)
      divHostView.reloadItem(cardId: params.cardId)
    case .empty,
         .url,
         .menu,
         .json,
         .composite:
      break
    }
  }
}
