//
//  ArrangeableSection.swift
//  MeuAlelo
//
//  Copyright © 2019 Alelo. All rights reserved.
//

import UIKit

class ArrangeableSection: TableViewSection {
    
    private var cellBuilders: [TableViewArrangeableCellBuilder]
    private var header: UIView?
    private var footer: UIView?
    
    typealias DisplayItemBlockType = (TableViewItem) -> Void
    private var willDisplayItem: DisplayItemBlockType?
    
    typealias MoveRowCompletion = (_ sourceIndexPath: IndexPath, _ destinationIndexPath: IndexPath) -> Void
    private var moveRowCompletion: MoveRowCompletion
    
    var numberOfRows: Int {
        return cellBuilders.count
    }
    
    init(cellBuilders: [TableViewArrangeableCellBuilder],
         header: UIView? = nil,
         footer: UIView? = nil,
         willDisplayItem: DisplayItemBlockType? = nil,
         moveRowCompletion: @escaping MoveRowCompletion) {
        self.header = header
        self.footer = footer
        self.cellBuilders = cellBuilders
        self.willDisplayItem = willDisplayItem
        self.moveRowCompletion = moveRowCompletion
    }
    
    func registerCells(in tableView: UITableView) {
        for builder in cellBuilders {
            builder.registerCellIdentifier(in: tableView)
        }
    }
    
    func cellHeight(forCellAt indexPath: IndexPath, on tableView: UITableView) -> CGFloat {
        return cellBuilders[indexPath.row].cellHeight
    }
    
    func tableViewCell(_ tableView: UITableView, shouldSelectCellAt indexPath: IndexPath) -> Bool {
        return cellBuilders[indexPath.row].tableViewShouldSelectCell(tableView)
    }
    
    func tableViewCell(_ tableView: UITableView, didSelectCellAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        return cellBuilders[indexPath.row].tableViewDidSelectCell(tableView)
    }
    
    func tableViewCell(at indexPath: IndexPath,
                       on tableView: UITableView) -> UITableViewCell {
        
        return cellBuilders[indexPath.row].tableViewCell(at: indexPath, on: tableView)
    }
    
    func tableViewSectionFooter(_ tableView: UITableView) -> UIView? {
        return footer
    }
    
    func tableViewSectionHeader(_ tableView: UITableView) -> UIView? {
        return header
    }
    
    func tableViewSectionHeaderHeight(_ tableView: UITableView) -> CGFloat {
        if header != nil {
            return UITableView.automaticDimension
        }
        return CGFloat.leastNonzeroMagnitude
    }
    
    func tableViewSectionFooterHeight(_ tableView: UITableView) -> CGFloat {
        if footer != nil {
            return UITableView.automaticDimension
        }
        return CGFloat.leastNonzeroMagnitude
    }
    
    func tableView(_ tableView: UITableView,
                   willDisplayFooterView view: UIView,
                   forSection section: Int) {
        self.willDisplayItem?(.footer)
    }
    
    func tableView(_ tableView: UITableView,
                   canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return cellBuilders[indexPath.row].canMove()
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        moveRowCompletion(sourceIndexPath, destinationIndexPath)
    }
}
