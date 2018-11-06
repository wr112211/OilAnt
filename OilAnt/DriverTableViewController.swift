//
//  DriverTableViewController.swift
//  OilAnt
//  车主-提交认证信息
//  Created by 王瑞 on 2018/11/6.
//  Copyright © 2018年 王瑞. All rights reserved.
//

import UIKit
import Alamofire

class DriverTableViewController: UITableViewController {

    var userAuthState = ""
    var clickAction = "1"
    var filePath1 = ""
    var filePath2 = ""
    var filePath3 = ""
    var filePath4 = ""
    var filePath5 = ""
    var filePath6 = ""
    var filePath7 = ""
    
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var userIdCard: UITextField!
    @IBOutlet weak var companyName: UITextField!
    @IBOutlet weak var listenPic1: UIImageView!
    @IBOutlet weak var litenPic2: UIImageView!
//    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var rolePic3: UIImageView!
    @IBOutlet weak var rolePic4: UIImageView!
    @IBOutlet weak var runPic5: UIImageView!
    @IBOutlet weak var roleRunPic6: UIImageView!
    @IBOutlet weak var roleRunPic7: UIImageView!
    @IBAction func submitBtn(_ sender: Any) {
        
        print("submitInfo")
        submitInfo()
    }
    
    //返回按钮点击响应
    @objc func backToPrevious(){
        self.dismiss(animated: true, completion: nil)
    }
    
//    @IBOutlet weak var totalView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
      
        let leftBarBtn = UIBarButtonItem(title: "返回", style: .plain, target: self,
                                         action: #selector(backToPrevious))
        self.navigationItem.leftBarButtonItem = leftBarBtn
        self.navigationItem.title = "车主认证"
        
        print("userAuthState",userAuthState)
        //        ios9 以前获取高度和宽度
        //
        //        let screenh = UIScreen.mainScreen().applicationFrame.size.height
        //
        //        let screenw = UIScreen.mainScreen().applicationFrame.size.width
        //
        //        ios9 以后获取高度和宽度
        //
//        let screenh = UIScreen.main.bounds.size.height
//        
//        let screenw = UIScreen.main.bounds.size.width
        
//        self.scrollview.isScrollEnabled = true;//控制是否可以滚动
//        self.scrollview.isUserInteractionEnabled = true;//控制是否可以响应用户点击事件（touch）
//        self.scrollview.canCancelContentTouches = true; //这个属性设置为true
//        self.scrollview.delaysContentTouches = false;//设置为false试试
//        self.scrollview.delegate = self
//        self.scrollview.bounces = true;//反弹效果
//        self.scrollview.contentSize = CGSize(width:screenw, height:screenh*3);
//        
//        self.totalView.isUserInteractionEnabled = true; //这个属性设置为true
//        self.totalView.frame = CGRect(x: 0, y: 0, width: screenw, height: screenh*3)
        
        listenPic1.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self,  action: #selector(DriverTableViewController.picTap))
        listenPic1.addGestureRecognizer(tapGesture)
        
        litenPic2.isUserInteractionEnabled = true
        let tapGesture2 = UITapGestureRecognizer(target: self,  action: #selector(DriverTableViewController.picTap1))
        litenPic2.addGestureRecognizer(tapGesture2)
        
        rolePic3.isUserInteractionEnabled = true
        let tapGesture3 = UITapGestureRecognizer(target: self,  action: #selector(DriverTableViewController.picTap3))
        rolePic3.addGestureRecognizer(tapGesture3)
        
        rolePic4.isUserInteractionEnabled = true
        let tapGesture4 = UITapGestureRecognizer(target: self,  action: #selector(DriverTableViewController.picTap4))
        rolePic4.addGestureRecognizer(tapGesture4)
        
        runPic5.isUserInteractionEnabled = true
        let tapGesture5 = UITapGestureRecognizer(target: self,  action: #selector(DriverTableViewController.picTap5))
        runPic5.addGestureRecognizer(tapGesture5)
        
        roleRunPic6.isUserInteractionEnabled = true
        let tapGesture6 = UITapGestureRecognizer(target: self,  action: #selector(DriverTableViewController.picTap6))
        roleRunPic6.addGestureRecognizer(tapGesture6)
        
        roleRunPic7.isUserInteractionEnabled = true
        let tapGesture7 = UITapGestureRecognizer(target: self,  action: #selector(DriverTableViewController.picTap7))
        roleRunPic7.addGestureRecognizer(tapGesture7)
        
    }
    //
    func submitInfo() {
        print(filePath1)
        print(filePath2)
        print(filePath3)
        print(filePath4)
        print(filePath5)
        print(filePath6)
        print(filePath7)
    }
    
    //图片上传
    class func requestUpload(url: String, params: [String: String], data: [Data], success: @escaping(_ response: [String: AnyObject])->(), fail:@escaping(_ error: Error) -> ()){
        
        let headers = ["content-type":"multipart/form-data"]
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            //多张图片上传
            //            let flag = params["flag"]
            //            let userId = params["userId"]
            //
            //            multipartFormData.append((flag?.data(using: String.Encoding.utf8))!, withName: "flag")
            //            multipartFormData.append((userId?.data(using: String.Encoding.utf8))!, withName: "userId")
            
            for i in 0..<data.count{
                //设置图片的名字
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyyMMddHHmmss"
                let string = formatter.string(from: Date())
                let filename = "\(string).jpg"
                multipartFormData.append(data[i], withName: "img", fileName: filename, mimeType: "image/jpeg")
            }
        }, to: url, headers: headers, encodingCompletion:{ encodingResult in
            switch encodingResult{
            case .success(request: let upload,_,_):
                upload.responseJSON(completionHandler: { (response) in
                    if let value = response.result.value as? [String : AnyObject]{
                        success(value)
                    }
                })
            case .failure(let error):
                fail(error)
            }
        })
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//MARK: 扩展图片选择和结果返回
extension DriverTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // MARK: 图片选择器界面
    var takeCameraController: UIImagePickerController {
        get {
            let imagePicket = UIImagePickerController()
            imagePicket.delegate = self
            imagePicket.sourceType = .camera
            imagePicket.allowsEditing = false
            return imagePicket
        }
    }
    
    // MARK: 图片选择器界面
    var imagePickerController: UIImagePickerController {
        get {
            let imagePicket = UIImagePickerController()
            imagePicket.delegate = self
            imagePicket.allowsEditing = false
            imagePicket.sourceType = .photoLibrary
            return imagePicket
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        
        //        var image =  UIImage(named: info[UIImagePickerController.InfoKey.originalImage] as! String)
        //修正图片的位置
        //先把图片转成NSData
        let data = image!.jpegData(compressionQuality: 0.5)!
        
        //这里为先前的写法，在Swift中路径有变化
        //--------------------------------------------------//
        //图片保存的路径
        //这里将图片放在沙盒的documents文件夹中
        let DocumentsPath:String = NSHomeDirectory().appendingFormat("YmYDocuments")
        
        //文件管理器
        let fileManager = FileManager.default
        
        //把刚刚图片转换的data对象拷贝至沙盒中 并保存为image.png
        try! fileManager.createDirectory(atPath: DocumentsPath, withIntermediateDirectories: true, attributes: nil)
        fileManager.createFile(atPath: DocumentsPath + "/image.png", contents: data, attributes: nil)
        
        if(clickAction == "1"){
            listenPic1.image = image
            filePath1 = DocumentsPath + "/image1.png"
        } else if (clickAction == "2"){
            litenPic2.image = image
            filePath2 = DocumentsPath + "/image2.png"
        } else if (clickAction == "3"){
            rolePic3.image = image
            filePath3 = DocumentsPath + "/image3.png"
        } else if (clickAction == "4"){
            rolePic4.image = image
            filePath4 = DocumentsPath + "/image4.png"
        } else if (clickAction == "5"){
            runPic5.image = image
            filePath5 = DocumentsPath + "/image5.png"
        } else if (clickAction == "6"){
            roleRunPic6.image = image
            filePath6 = DocumentsPath + "/image6.png"
        } else if (clickAction == "7"){
            roleRunPic7.image = image
            filePath7 = DocumentsPath + "/image7.png"
        }
        
        //        listenPic1.contentMode = .scaleToFill // 缩放显示, 便于查看全部的图片
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: 当点击图片选择器中的取消按钮时回调
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("imgpicker")
        picker.dismiss(animated: true, completion: nil) // 效果一样的...
    }
}

//MARK: 轻触 图片控件
extension DriverTableViewController {
    
    // MARK: 用于弹出选择的对话框界面
    var selectorController: UIAlertController {
        let controller = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        controller.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil)) // 取消按钮
        controller.addAction(UIAlertAction(title: "拍照选择", style: .default) { action in
            self.selectorSourceType(type: .camera)
        }) // 拍照选择
        controller.addAction(UIAlertAction(title: "相册选择", style: .default) { action in
            self.selectorSourceType(type: .photoLibrary)
        }) // 相册选择
        return controller
    }
    
    
    
    @objc func picTap()
    {
        print("1")
        clickAction = "1"
        present(selectorController, animated: true, completion: nil)
    }
    @objc func picTap1()
    {
        print("2")
        clickAction = "2"
        present(selectorController, animated: true, completion: nil)
    }
    @objc func picTap3()
    {
        print("3")
        clickAction = "3"
        present(selectorController, animated: true, completion: nil)
    }
    @objc func picTap4()
    {
        print("4")
        clickAction = "4"
        present(selectorController, animated: true, completion: nil)
    }
    @objc func picTap5()
    {
        print("5")
        clickAction = "5"
        present(selectorController, animated: true, completion: nil)
    }
    @objc func picTap6()
    {
        print("6")
        clickAction = "6"
        present(selectorController, animated: true, completion: nil)
    }
    @objc func picTap7()
    {
        print("7")
        clickAction = "7"
        present(selectorController, animated: true, completion: nil)
    }
    
    
    func selectorSourceType(type: UIImagePickerController.SourceType) {
        imagePickerController.sourceType = type
        if(type == .camera){
            guard UIImagePickerController.isSourceTypeAvailable(.camera)
                else {
                    print("摄像头不可用")
                    return
            }
            // 打开图片选择器
            present(takeCameraController, animated: true, completion: nil)
        } else {
            guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary)
                else {
                    print("相册不可用")
                    return
            }
            // 打开图片选择器
            present(imagePickerController, animated: true, completion: nil)
        }
        
        
    }
}

