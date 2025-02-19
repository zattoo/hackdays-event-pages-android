@testable import LayoutKit
@testable import DivKit

import XCTest

final class DivContainerExtensionsTests: XCTestCase {
  func test_WhenDivHasAction_CreatesBlockWithIt() throws {
    let block = try makeBlock(fromFile: "with_action") as? DecoratingBlock

    XCTAssertEqual(block?.actions, Expected.actions)
  }

  func test_WhenDivHasMultiActions_CreatesBlockWithIt() throws {
    let block = try makeBlock(fromFile: "with_multi_actions") as? DecoratingBlock

    XCTAssertEqual(block?.actions, Expected.multiActions)
  }

  func test_WhenDivHasActionsWithMenu_CreatesBlockWithIt() throws {
    let block = try makeBlock(fromFile: "with_multi_actions_with_menu") as? DecoratingBlock

    XCTAssertEqual(block?.actions, Expected.menuAction)
  }

  func test_WhenDivHasSetStateAction_CreatesBlockWithIt() throws {
    let block = try makeBlock(
      fromFile: "with_set_state_action"
    ) as? DecoratingBlock

    XCTAssertEqual(block?.actions, Expected.setStateActions)
  }

  func test_WhenCantBuildBlockForItems_ThrowsError() {
    XCTAssertThrowsError(
      try makeBlock(fromFile: "invalid_items"),
      DivBlockModelingError(
        "DivContainer is empty",
        path: .root + "container"
      )
    )
  }

  func test_AddsIndexedParentPathToItems() throws {
    let block = try makeBlock(
      fromFile: "item_with_action"
    ) as? WrapperBlock

    let container = block?.child as? ContainerBlock
    let wrappedContainer = container?.children.first?.content as? WrapperBlock
    let gallery: GalleryBlock? = wrappedContainer?.child as? GalleryBlock

    // We are using "container" const instead of DivContainer.type to emphasise its importance for analytics.
    // DivContainer.type changes can brake analytic reports.
    XCTAssertEqual(
      gallery?.model.path,
      UIElementPath.root + "container" + 0 + "gallery"
    )
  }

  func test_HorizontalWrapContainer_HasVerticallyResizableItem_FallbackHeight(
  ) throws {
    try assertBlocksAreEqual(
      in: "horizontal_wrap_container_match_parent_height_item",
      "horizontal_wrap_container_wrap_content_constrained_height_item"
    )
  }

  func test_VerticalWrapContainer_HasHorizontallyResizableItem_FallbackWidth(
  ) throws {
    try assertBlocksAreEqual(
      in: "vertical_wrap_container_match_parent_width_item",
      "vertical_wrap_container_wrap_content_constrained_width_item"
    )
  }

  func test_HorizontalContainer_WithIntrinsicWidth_AndHasSingleHorizontallyResizableItem_FallbackWidth(
  ) throws {
    try assertBlocksAreEqual(
      in: "wrap_content_width_match_parent_items",
      "wrap_content_width_wrap_content_constrained_items"
    )
  }

  func test_HorizontalContainer_WithIntrinsicWidth_AndHasHorizontallyResizableItem_FallbackWidth(
  ) throws {
    try assertBlocksAreEqual(
      in: "horizontal_wrap_content_width_match_parent_item",
      "horizontal_wrap_content_width_wrap_content_constrained_item"
    )
  }

  func test_HorizontalContainer_WithIntrinsicHeight_AndAllItemsAreVerticallyResizable_FallbackHeight(
  ) throws {
    try assertBlocksAreEqual(
      in: "horizontal_wrap_content_height_match_parent_items",
      "horizontal_wrap_content_height_wrap_content_constrained_items"
    )
  }

  func test_VerticalContainer_WithIntrinsicWidth_AndAllItemsAreHorizontallyResizable_FallbackWidth(
  ) throws {
    try assertBlocksAreEqual(
      in: "vertical_wrap_content_width_match_parent_items",
      "vertical_wrap_content_width_wrap_content_constrained_items"
    )
  }

  func test_VerticalContainer_WithIntrinsicHeight_AndHasVerticallyResizableItem_FallbackHeight(
  ) throws {
    try assertBlocksAreEqual(
      in: "vertical_wrap_content_height_match_parent_item",
      "vertical_wrap_content_height_wrap_content_constrained_item"
    )
  }

  func test_OverlapContainer_WithIntrinsicWidth_AndAllItemsAreHorizontallyResizable_FallbackWidth(
  ) throws {
    try assertBlocksAreEqual(
      in: "overlap_wrap_content_width_match_parent_items",
      "overlap_wrap_content_width_wrap_content_constrained_items"
    )
  }

  func test_OverlapContainer_WithIntrinsicHeight_AndAllItemsAreVerticallyResizable_FallbackHeight(
  ) throws {
    try assertBlocksAreEqual(
      in: "overlap_wrap_content_height_match_parent_items",
      "overlap_wrap_content_height_wrap_content_constrained_items"
    )
  }

  func test_AxialItemsAlignmentsAreIgnoredInHorizontalContainer() throws {
    try assertBlocksAreEqual(
      in: "horizontal_orientation_axial_alignments",
      "horizontal_orientation_no_alignments"
    )
  }

  func test_AxialItemsAlignmentsAreIgnoredInVerticalContainer() throws {
    try assertBlocksAreEqual(
      in: "vertical_orientation_axial_alignments",
      "vertical_orientation_no_alignments"
    )
  }

  private func assertBlocksAreEqual(in files: String...) throws {
    let first = try makeBlock(fromFile: files[0])
    for file in files.dropFirst() {
      XCTAssertTrue(try first == makeBlock(fromFile: file))
    }
  }
}

private func makeBlock(fromFile filename: String) throws -> Block {
  try DivContainerTemplate.make(
    fromFile: filename,
    subdirectory: "div-container",
    context: .default
  )
}
