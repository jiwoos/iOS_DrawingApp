//
//  ViewController.swift
//  DrawingApp
//
//  Created by Jiwoo Seo on 6/29/20.
//  Copyright © 2020 Jiwoo Seo. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    
    @IBOutlet weak var hexInput: UITextField!
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var hexSubmitButton: UIButton!
    
    var currentLine: Line?
    var lineCanvas: LineView!
    var penColor = UIColor.black
    var penWidth:CGFloat = 9
    
    @IBOutlet weak var thicknessValue: UISlider!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction func undoButton(_ sender: Any) {
        if lineCanvas.lineStored.count > 0 {
            lineCanvas.theLine = nil
            lineCanvas.lineStored.removeLast()
        }
    }
    
    @IBAction func clearButton(_ sender: Any) {
        lineCanvas.theLine = nil
        lineCanvas.lineStored = []
    }
    

    @IBAction func thicknessChanged(_ sender: Any) {
        penWidth = CGFloat(thicknessValue.value)
    }
    
 
    @IBAction func blackButton(_ sender: Any) {
        penColor = UIColor.black
    }
    
    
    @IBAction func pinkBUtton(_ sender: Any) {
        penColor = UIColor(named: "Pink")!
    }
    

    @IBAction func yellowButton(_ sender: Any) {
        penColor = UIColor(named: "Yellow")!
    }
    
    
    @IBAction func blueButton(_ sender: Any) {
        penColor = UIColor(named: "Blue")!
    }
    
    
    @IBAction func greenButton(_ sender: Any) {
        penColor = UIColor(named: "Green")!
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        lineCanvas = LineView(frame: view.frame)
        view.addSubview(lineCanvas)
        view.sendSubviewToBack(lineCanvas)
        thicknessValue.maximumValue = 18
        thicknessValue.minimumValue = 1
        thicknessValue.value = 9
        hexSubmitButton.layer.cornerRadius = 5
        hexSubmitButton.layer.borderWidth = 1
        hexSubmitButton.layer.borderColor = hexSubmitButton.backgroundColor?.cgColor
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touchPoint = (touches.first)!.location(in: view) as CGPoint
        currentLine = Line(line: touchPoint, color: penColor, width: penWidth)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touchPoint = (touches.first)!.location(in: view) as CGPoint
        currentLine?.lines.append(touchPoint)
        lineCanvas.theLine = currentLine
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let newLine = currentLine {
            lineCanvas.theLine = currentLine
            lineCanvas.lineStored.append(newLine)
        }
    }
    
    
    
    
    
    
    
    
    
    
    // Creative Portion
    
    
    /* Few parts were taken from http://blog.naver.com/PostView.nhn?blogId=eaeao&logNo=220192122317&parentCategoryNo=&categoryNo=62&viewDate=&isShowPopularPosts=false&from=postView
     */
    @IBAction func submitHexValue(_ sender: Any) {
        let hexAlert = UIAlertController(title: "Wrong hex color", message: "do not include 0x or #", preferredStyle: .alert)
        let hexOK = UIAlertAction(title: "Okay", style: .default, handler: nil)
        guard let hexString = hexInput.text else { return }
        if let hexDecimal = Int(hexString, radix: 16) {
            let r = Float((hexDecimal >> 16) & 0xFF)
            let g = Float((hexDecimal >> 8) & 0xFF)
            let b = Float((hexDecimal) & 0xFF)
            let alpha:Float = 1
            penColor = UIColor(red: CGFloat(r / 255.0), green: CGFloat(g / 255.0), blue:CGFloat(b / 255.0), alpha: CGFloat(alpha))
        }
        else {
            hexAlert.addAction(hexOK)
            self.present(hexAlert, animated: true, completion: nil)
        }
    }
    
    
    
    
    /*
     Citation:
     https://www.youtube.com/watch?v=E2NTCmEsdSE
     https://www.youtube.com/watch?v=kAiknPhkWmc
     */
    @IBAction func openImage(_ sender: Any) {
        let imgPickerCtrl = UIImagePickerController()
        imgPickerCtrl.delegate = self
        let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a source", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "camera", style: .default, handler: { (actions: UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imgPickerCtrl.sourceType = .camera
                self.present(imgPickerCtrl, animated: true, completion: nil)
            }
            else {
                print("Camera is not available!")
            }
        }))
        actionSheet.addAction(UIAlertAction(title: "photo library", style: .default, handler: { (actions: UIAlertAction) in imgPickerCtrl.sourceType = .photoLibrary
            self.present(imgPickerCtrl, animated: true, completion: nil)
        }))
        actionSheet.addAction(UIAlertAction(title: "never mind", style: .cancel, handler: nil))
        self.present(actionSheet, animated:true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        imageView.image = image
        view.sendSubviewToBack(imageView)
        picker.dismiss(animated:true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func saveImage(_ sender: Any) {
        view.bringSubviewToFront(lineCanvas)
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, imageView.contentScaleFactor)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return  }
        UIGraphicsEndImageContext()
        view.sendSubviewToBack(lineCanvas)
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(imgSaved), nil)
        let saveAlert = UIAlertController(title: "Saved", message: "Check your photo library!", preferredStyle: .alert)
        let saveOkay = UIAlertAction(title: "Okay", style: .default, handler: nil)
        saveAlert.addAction(saveOkay)
        self.present(saveAlert, animated: true, completion: nil)
    }
    
    @objc func imgSaved(_ image: UIImage, didFinishSavingWithError error: Error?, contextType: UnsafeRawPointer) {
        if error != nil {
            print("unable to save")
        } else {
            print("image saved")
        }
    }
}



    /* round button for color palette : https://stackoverflow.com/questions/49047818/making-buttons-circular-in-swift4
    */

@IBDesignable class RoundButton : UIButton{
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }
    
    override func prepareForInterfaceBuilder() {
        sharedInit()
    }
    
    func sharedInit() {
        refreshCorners(value: cornerRadius)
    }
    
    func refreshCorners(value: CGFloat) {
        layer.cornerRadius = value
    }
    
    @IBInspectable var cornerRadius: CGFloat = 15 {
        didSet {
            refreshCorners(value: cornerRadius)
        }
    }
}
