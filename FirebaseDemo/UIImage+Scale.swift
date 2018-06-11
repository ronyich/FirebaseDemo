//
//  UIImage+Scale.swift
//  FirebaseDemo
//
//  Created by Ron Yi on 2018/6/3.
//  Copyright © 2018年 AppCoda. All rights reserved.
//

import UIKit

extension UIImage {
    // 限制要上傳的圖片解析度，並視情況縮小 (因為內建高解析度相機，大小會超過1MB)
    func scale(newWidth: CGFloat) -> UIImage {
        // 確認所給定的寬度與目前的不同
        if self.size.width == newWidth {
            return self
        }
        
        // 計算縮放因子
        let scaleFactor = newWidth / self.size.width
        let newHeight = self.size.height * scaleFactor
        let newSize = CGSize(width: newWidth, height: newHeight)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        self.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        
        let newImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage ?? self
    }
}
