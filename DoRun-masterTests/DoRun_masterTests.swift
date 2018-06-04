//
//  DoRun_masterTests.swift
//  DoRun-masterTests
//
//  Created by guo-pf on 2018/6/4.
//  Copyright © 2018年 guo-pf. All rights reserved.
//

import XCTest
@testable import DoRun_master

class DoRun_masterTests: XCTestCase {
    
    func testDoRunLoop() {
        let loops = ["aaa","bbb","ccc"]
        let pams = "abc"
        let doNow = DoNow()
        let isSucess = true
        doNow.doRun(pams) { (classType, result, index) in
            if isSucess {
                doNow.transfer(value: "OK", error: nil)
            }else{
                let error : Error? = nil
                doNow.jumpToEnd(value: "no", error:error)
            }
            
            }.doRunLoop(index: loops.count)
            .doEnd(nil) { (classType, pams, result) in
        }
        
    }
    func testDoRunNext() {
        let pams0 = "abc"
        let pams1 = "abc"
        let pams2 = "abc"
        let doNow = DoNow()
        let isSucess = true
        doNow.doRun(pams0) { (classType, result, index) in
            if isSucess {
                doNow.transfer(value: "OK", error: nil)
            }else{
                let error : Error? = nil
                doNow.jumpToEnd(value: "no", error:error)
            }
            }.doNext(pams1) { (classType, pams, result) in
                if isSucess {
                    doNow.transfer(value: "OK", error: nil)
                }else{
                    let error : Error? = nil
                    doNow.jumpToEnd(value: "no", error:error)
                }
            }.doNext(nil) { (classType, pams, result) in
                if isSucess {
                    doNow.transfer(value: "OK", error: nil)
                }else{
                    let error : Error? = nil
                    doNow.jumpToEnd(value: "no", error:error)
                }
            }.doNext(pams2) { (classType, pams, result) in
                if isSucess {
                    doNow.transfer(value: "OK", error: nil)
                }else{
                    let error : Error? = nil
                    doNow.jumpToEnd(value: "no", error:error)
                }
            }.doEnd(nil) { (classType, pams, result) in
                
        }
    }
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
