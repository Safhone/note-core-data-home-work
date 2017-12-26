//
//  ViewController.swift
//  Core-Data
//
//  Created by Safhone Oung on 12/20/17.
//  Copyright © 2017 Safhone Oung. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController{

    @IBOutlet weak var noteCollectionView: UICollectionView!
    
    let CONTEXT = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var notes: [Note]?
    var noteCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true

        noteCollectionView.delegate = self
        noteCollectionView.dataSource = self

        let collectionCellLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionCellLayout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        collectionCellLayout.minimumLineSpacing = 10
        let width = self.view.frame.size.width / 2 - 15
        let height = self.view.frame.size.height / 4
        collectionCellLayout.itemSize = CGSize(width: width, height: height)
        noteCollectionView.collectionViewLayout = collectionCellLayout
        
        notes = try? CONTEXT.fetch(Note.fetchRequest())
        noteCollectionView.reloadData()
        noteCount = notes!.count
        
        let noteLongPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(noteEditLongPressed))
        noteLongPressGesture.minimumPressDuration = 1
        self.noteCollectionView.addGestureRecognizer(noteLongPressGesture)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.topItem?.title = "Notes"
        notes = try! CONTEXT.fetch(Note.fetchRequest())
        noteCollectionView.reloadData()
        
    }
    
    @IBAction func showNoteDetail(_ sender: Any) {
        performSegue(withIdentifier: "NoteDetailSegue", sender: nil)
    }
    
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return notes!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "noteCell", for: indexPath) as! CustomNoteCollectionViewCell
        cell.configurationCell(title: notes![indexPath.item].title!, note: notes![indexPath.item].note!)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let noteDetailStoryboard = self.storyboard?.instantiateViewController(withIdentifier: "DetailNoteStoryBoardID") as! NoteDetailViewController
        noteDetailStoryboard.titleNote = notes![indexPath.item].title!
        noteDetailStoryboard.note = notes![indexPath.item].note
        noteDetailStoryboard.isAlreadyAdd = true
        noteDetailStoryboard.noteIndexPath = indexPath.item
        
        self.navigationController?.pushViewController(noteDetailStoryboard, animated: true)
    }
    
}

extension ViewController: UIGestureRecognizerDelegate {
    @objc func noteEditLongPressed(press: UILongPressGestureRecognizer) {
        if press.state == .began {
            let indexPath = self.noteCollectionView.indexPathForItem(at: press.location(in: noteCollectionView))
            
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (action) in
                self.CONTEXT.delete(self.notes![indexPath!.item])
                self.notes = try! self.CONTEXT.fetch(Note.fetchRequest())
                (UIApplication.shared.delegate as! AppDelegate).saveContext()
                
                self.noteCollectionView.performBatchUpdates({
                    self.noteCollectionView.deleteItems(at: [indexPath!])
                    self.noteCount -= 1
                }, completion: nil)
                
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            present(alert, animated: true, completion: nil)
        }
    }
}


@IBDesignable extension UINavigationController {
    @IBInspectable var batTintColor: UIColor? {
        set {
            guard let uiColor = newValue else {
                return
            }
            navigationBar.barTintColor = uiColor
        }
        get {
            guard let color = navigationBar.tintColor else {
                return nil
            }
            return color
        }
    }
    
    @IBInspectable var TintColor: UIColor? {
        set {
            navigationBar.barTintColor = newValue
        }
        get {
            guard let color = navigationBar.tintColor else {
                return nil
            }
            return color
        }
    }
}
