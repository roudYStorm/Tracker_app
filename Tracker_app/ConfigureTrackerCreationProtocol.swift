import Foundation

protocol ConfigureUIForTrackerCreationProtocol: AnyObject {
    func configureButtonsCell(cell: ButtonsCell)
    func setupBackground()
    func calculateTableViewHeight(width: CGFloat) -> CGSize
    func checkIfSaveButtonCanBePressed()
}
