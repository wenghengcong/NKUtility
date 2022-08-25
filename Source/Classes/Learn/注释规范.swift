//
//  注释规范.swift
//  Alamofire
//
//  Created by Nemo on 2022/8/24.
//

import Foundation


/// 参考 [markup语法]( https://developer.apple.com/library/archive/documentation/Xcode/Reference/xcode_markup_formatting_ref/index.html#//apple_ref/doc/uid/TP40016497-CH2-SW1)
fileprivate class _NKCommontGuideGuide {
    // MARK: 这个是标示
    // MARK: - 这个是带分割线的标示
    // FIXME: 修复我
    // TODO: 待办
    // ???:  疑问
    // !!!:  旗帜
    
    /**
     两个整数相加
     # 加法（标题一）
     这个方法执行整数的加法运算。
     ## 加法运算（标题二）
     想加个试试看
     
     中间隔着一个横线
     ***
     
     代码块的*使用*方法:
     ```
     let num = func add(a: 1, b: 2)
     // print 3
     ```
     
     - c: 参数一
     - d: 参数二
     - f: 参数三
     
     - Parameters:
        - a: 加号左边的整数
        - b: 加号右边的整数
     - Throws: 抛出错误，此方法不抛出错误，只为另外演示注释用法。
     - Returns: 两个数的和
     - Important: 注意这个方法的参数。
     - Version: 1.0.0
     - Authors: Wei You, Fang Wang
     - Copyright: 版权所有
     - Date: 2020-12-28
     - Since: 1949-10-01
     - Attention: 加法的运算
     - Note: 提示一下，用的时候请注意类型。
     - Remark: 从新标记一下这个方法。
     - Warning: 警告，这是一个没有内容的警告。
     - Bug: 标记下bug问题。
     - TODO: 要点改进的代码
     - Experiment: 试验点新玩法。
     - Precondition: 使用方法的前置条件
     - Postcondition：使用方法的后置条件
     - Requires: 要求一些东西，才能用这个方法。
     - Invariant: 不变的
     */
    func add(a: Int, b: Int) throws -> Int {
        return a + b
    }
}



