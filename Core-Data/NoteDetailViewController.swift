//
//  NoteDetailViewController.swift
//  Core-Data
//
//  Created by Safhone Oung on 12/20/17.
//  Copyright © 2017 Safhone Oung. All rights reserved.
//

import UIKit
import CoreData

class NoteDetailViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var noteTextView: UITextView!
    
    let CONTEXT = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var titleNote: String?
    var note: String?
    var isAlreadyAdd: Bool = false
    var noteIndexPath: Int?
    var notes: [Note]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleTextField.text = titleNote
        noteTextView.text = note
        self.navigationController?.navigationBar.topItem?.title = ""
        
        if noteTextView == nil || noteTextView.text.trimmingCharacters(in: .whitespaces).count == 0 {
            noteTextView.text = "Note"
            noteTextView.textColor = UIColor.lightGray
        }
        
        noteTextView.delegate = self
        
        //Scroll TextView When KeyBoard Appear
        NotificationCenter.default.addObserver(self,selector: #selector(keyboardWillShowForResizing), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHideForResizing), name: Notification.Name.UIKeyboardWillHide, object: nil)
        
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        if self.isMovingFromParentViewController {
            if isAlreadyAdd == false {
                if !(noteTextView.textColor == UIColor.lightGray) {
                    if titleTextField.text == "" || titleTextField.text == nil {
                        titleTextField.text = "Untitle"
                    }
                    let note = Note(context: CONTEXT)
                    note.title = titleTextField.text
                    note.note = noteTextView.text
                    (UIApplication.shared.delegate as! AppDelegate).saveContext()
                }
            } else {
                var notes: [Note] = try! CONTEXT.fetch(Note.fetchRequest())
                notes[noteIndexPath!].title = titleTextField.text
                notes[noteIndexPath!].note = noteTextView.text
                (UIApplication.shared.delegate as! AppDelegate).saveContext()
            }
        }
    }
   
    @IBAction func alertAddMore(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let takePhoto = UIAlertAction(title: "Take photo", style: .default) { (action) in
                print("Take photo")
        }
        
        let chooseImage = UIAlertAction(title: "Choose image", style: .default) { (action) in
            print("Choose image")
        }
        
        let drawing = UIAlertAction(title: "Drawing", style: .default) { (action) in
            print("Drawing")
        }
        
        let recording = UIAlertAction(title: "Recording", style: .default) { (action) in
            print("Recording")
        }

        let checkbox = UIAlertAction(title: "Checkboxes", style: .default) { (action) in
            print("Checkboxes")
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            print("cancel")
        }
    
        alert.addAction(takePhoto)
        alert.addAction(chooseImage)
        alert.addAction(drawing)
        alert.addAction(recording)
        alert.addAction(checkbox)
        alert.addAction(cancel)

        present(alert, animated: true)

    }
    
    @IBAction func moreBarItemButton(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        let delete = UIAlertAction(title: "Delete", style: .default) { (action) in
            print("Delete")
        }

        let makeACopy = UIAlertAction(title: "Make a copy", style: .default) { (action) in
            print("Make a copy")
        }

        let send = UIAlertAction(title: "Send", style: .default) { (action) in
            print("Send")
        }

        let collaborator = UIAlertAction(title: "Collaborators", style: .default) { (action) in
            print("Collaborator")
        }
        let label = UIAlertAction(title: "Labels", style: .default) { (action) in
            print("label")
        }

        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            print("cancel")
        }

        alert.addAction(delete)
        alert.addAction(makeACopy)
        alert.addAction(send)
        alert.addAction(collaborator)
        alert.addAction(label)
        alert.addAction(cancel)

        present(alert, animated: true)

    }
    
    @objc func keyboardWillShowForResizing(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
            let window = self.view.window?.frame {
            self.view.frame = CGRect(x: self.view.frame.origin.x, y: self.view.frame.origin.y, width: self.view.frame.width, height: window.origin.y + window.height - keyboardSize.height)
        }
    }
    
    @objc func keyboardWillHideForResizing(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let viewHeight = self.view.frame.height
            self.view.frame = CGRect(x: self.view.frame.origin.x, y: self.view.frame.origin.y, width: self.view.frame.width, height: viewHeight + keyboardSize.height)
        }
    }
    
}

extension NoteDetailViewController: UITextViewDelegate, UITextFieldDelegate{
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Note"
            textView.textColor = UIColor.lightGray
        }
    }
    
}
