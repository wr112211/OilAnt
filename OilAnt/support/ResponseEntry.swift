//
//  ResponseEntry.swift
//  OilAnt
//
//  Created by 王瑞 on 2018/11/6.
//  Copyright © 2018年 王瑞. All rights reserved.
//

import UIKit
import HandyJSON


// 假设这是服务端返回的统一定义的response格式
class BaseResponse<T: HandyJSON>: HandyJSON {
    var code: Int? // 服务端返回码
    var msg = "";
    var data: T? // 具体的data的格式和业务相关，故用泛型定义
    
    public required init() {}
}

class ResponseEntry: HandyJSON {
    var code = "";
    var msg = "";
    var data: [IndentEntry]?
    
    //    var score: Double? = 0.0
    //必须实现
    required init() {
        
    }
}

class IndentEntry: HandyJSON {
    var  startDetail = ""//开始地点
    var  finishDetail = ""//结束地点
    var  process = ""//状态
    var  goodName = ""//货品
    var  goodCategory = ""//货品
    var  volume = "";//货量
    var  actualVolume = "";//实际货量
    var  deliveryStartDate = "";//开始时间
    var  deliveryLastDate = "";//结束时间
    var  deliveryEndDate = "";
    var  deliveryToDate = "";
    var  amount = "";//总金额
    var  id = "";
    var  type = "";
    var  status = "";
    var  distance = "";
    var  unitPrice = "";
    var  createTime = "";
    var  encrypt = "";//是否有密码
    var  isSelect = "";
    //出发城市
    var  startDistrict = "";
    //目的城市
    var  finishDistrict = "";
    
    //    var score: Double? = 0.0
    var authenticationed = "";
    var certNo = "";
    var certStatus = "";
    var company = "";
    //    var id = 22;
    var latestAuthentication = "";
    var maxLoad = "";
    var mobile = "";
    var newCarAuthed = "";
    var plateNumber = "";
    var realname = "";
    var registId = "";
    var result = "";
    var resultInfo = "";
    var role = "";
    var username = "";
    //必须实现
    required init() {
        
    }
}

class TestHandyJsonList: HandyJSON {
    //数组list
    var list: [ResponseEntry]! = []
    
    //必须实现
    required init() {
        
    }
}
