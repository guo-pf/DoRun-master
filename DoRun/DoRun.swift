//
//  DoRun.swift
//  DoRun
//
//  Created by guo-pf on 2018/6/3.
//  Copyright © 2018年 guo-pf. All rights reserved.
//

import Foundation

fileprivate protocol DoNext {
    var result: Result? { get set }
    var subscribe : RunSubscribe? { get set }
    var signal :RunSignal? { get set }
}

struct Result  {
    var error : Error?
    var value : Any?
    init(value:Any? , error:Error?) {
        self.value = value
        self.error = error
    }
}

extension DoNext where Self : Any {
    
    fileprivate func createSubscribe(){
        var newSelf = self
        newSelf.signal = RunSignal(effectiveSignal: true)
        newSelf.subscribe = RunSubscribe(signal: signal!, count: 0)
    }
    
    
    fileprivate func doRunPro(_ parameter:Any? = nil ,
                              index:NSInteger,
                              queue:DispatchQueue ,
                              group: DispatchGroup,
                              semaphore: DispatchSemaphore,
                              doRunLoop:Bool,
                              comletion: @escaping(_ classType:Self, _ parameter : Any? , _ index : NSInteger )->()) -> Self{
        var newSelf = self
        if !doRunLoop {
            group.enter()
            semaphore.wait()
            queue.async(){
                guard (newSelf.signal?.count)! >= 0 else{
                    semaphore.signal()
                    group.leave()
                    newSelf.subscribe = RunSubscribe(signal: newSelf.signal!, count: -1)
                    self.doEndPro(queue: queue,
                                  group: group,
                                  semaphore: semaphore,
                                  comletion: {(newSelf,parameter,nil) in})
                    return
                }
                
                comletion(newSelf,parameter, index)
            }
            return newSelf
        }else{
            semaphore.wait()
            guard (newSelf.signal?.count)! >= 0 else{
                semaphore.signal()
                group.leave()
                newSelf.subscribe = RunSubscribe(signal: newSelf.signal!, count: -1)
                self.doEndPro(queue: queue,
                              group: group,
                              semaphore: semaphore,
                              comletion: {(newSelf,parameter,nil) in})
                return newSelf
            }
            comletion(newSelf,parameter, index)
            return newSelf
        }
    }
     fileprivate func doNextPro(_ parameter:Any? = nil  ,
                                queue:DispatchQueue ,
                                group: DispatchGroup,
                                semaphore: DispatchSemaphore,
                                comletion: @escaping(_ classType:Self, _ parameter : Any? , _ result:Result?)->()) -> Self{
         var newSelf = self
         queue.async(){
                semaphore.wait()
                group.enter()
                guard (newSelf.signal?.count)! >= 0 else{
                    semaphore.signal()
                    group.leave()
                    self.doEndPro(queue: queue,
                                  group: group,
                                  semaphore: semaphore,
                                  comletion: comletion)
                    return
                }
                newSelf.signal?.count = 0
                comletion(newSelf,parameter,newSelf.result)
            }
            return newSelf
    }
    fileprivate func doEndPro(_ parameter:Any? = nil  ,
                              queue:DispatchQueue ,
                              group: DispatchGroup,
                              semaphore: DispatchSemaphore,
                              comletion: @escaping(_ classType:Self, _ parameter : Any? , _ result:Result?)->()) {
        queue.async(){
            semaphore.wait()
            group.notify(queue: DispatchQueue.main, execute: {
                var newSelf = self
                guard (newSelf.signal?.effectiveSignal)! else{
                    return
                }
                newSelf.signal = RunSignal(effectiveSignal: false)
                newSelf.subscribe = RunSubscribe(signal: self.signal!, count: -1)
                comletion(newSelf,parameter,newSelf.result)
            })
        }
    }
    
    fileprivate func doRunLoopPro(index:NSInteger,
                                  queue:DispatchQueue ,
                                  group: DispatchGroup,
                                  semaphore: DispatchSemaphore,
                                  comletion: @escaping (_ classType:Self, _ parameter : Any?, _ index : NSInteger )->()) -> Self{
        var newSelf = self
        if index>=2 {
            queue.async(){
                for i in 1..<index {
                    group.enter()
                    newSelf = newSelf.doRunPro(index: i,
                                             queue: queue,
                                             group: group,
                                             semaphore: semaphore,
                                             doRunLoop:true,
                                             comletion: comletion)

                }
            }
        }
         return newSelf
    }
    
     fileprivate func transferPro(value : Any? = nil,
                                  group: DispatchGroup,
                                  semaphore: DispatchSemaphore,
                                  error:Error? = nil) {
        var newSelf = self
        newSelf.result = Result(value: value, error: error)
        group.leave()
        semaphore.signal()
    }
    fileprivate func jumpToEndPro(value : Any? = nil,
                                  group: DispatchGroup,
                                  semaphore: DispatchSemaphore,
                                  error:Error? = nil) {
         var newSelf = self
        newSelf.subscribe = RunSubscribe(signal: newSelf.signal!, count: -1)
        transferPro(value: value, group: group, semaphore: semaphore, error: error)
    }
}

class DoNow : DoNext{
    fileprivate var result: Result?
    fileprivate var subscribe: RunSubscribe?
    fileprivate var signal: RunSignal?
    fileprivate var isJump: Bool = false
    fileprivate var comletions : Any?
    
    fileprivate var queue: DispatchQueue  = DispatchQueue(label: "com.gpf.doRun")
    fileprivate var group: DispatchGroup  = DispatchGroup()
    fileprivate var semaphore: DispatchSemaphore = DispatchSemaphore(value: 0)
    
    
    func doRun(_ parameter: Any?,
               comletion: @escaping (DoNow, Any?, NSInteger) -> ()) -> DoNow {
       semaphore.signal()
        comletions = comletion
        createSubscribe()
       return doRunPro(parameter,
                       index: 0,
                       queue: queue,
                       group: group,
                       semaphore: semaphore,
                       doRunLoop: false,
                       comletion: comletion)
    }
    func doNext(_ parameter: Any?,
                comletion: @escaping (DoNow, Any?, Result?) -> ()) -> DoNow {
        return doNextPro(parameter,
                         queue: queue,
                         group: group,
                         semaphore: semaphore,
                         comletion: comletion)
    }
    func doEnd(_ parameter: Any? = nil,
               comletion: @escaping (DoNow, Any?, Result?) -> ())  {
        doEndPro(parameter,
                 queue: queue,
                 group: group,
                 semaphore: semaphore,
                 comletion: comletion)
    }
    func transfer(value : Any? = nil,
                  error:Error? = nil) {
        transferPro(value: value,
                    group: group,
                    semaphore: semaphore,
                    error: error)
    }
    func jumpToEnd(value : Any? = nil,
                   error:Error? = nil) {
        jumpToEndPro(value: value,
                     group: group,
                     semaphore: semaphore,
                     error: error)
    }
    func doRunLoop(index:NSInteger) -> DoNow  {
        return doRunLoopPro(index: index,
                            queue: queue,
                            group: group,
                            semaphore: semaphore,
                            comletion: comletions as! ((DoNow, Any?,NSInteger) -> ()))
    }
}

fileprivate class RunSignal {
    fileprivate var effectiveSignal : Bool = false      //false 为无效信号
    fileprivate var count: NSInteger = -1       //计数   0时候可执行，-1时候跳出
    init(effectiveSignal:Bool){    //是否为有效信号量
        self.effectiveSignal = effectiveSignal
        if !effectiveSignal { count = -1 }
    }
    //空信号
    func emtySignal() -> RunSignal {
        return RunSignal(effectiveSignal: false)
    }
    //创建信号
    func createSignal() -> RunSignal {
        return RunSignal(effectiveSignal: true)
    }
}

fileprivate class RunSubscribe {
    var signal: RunSignal?          //开始订阅，开始创建信号
    //开启订阅
    init(signal:RunSignal, count:NSInteger? = -1) {
        self.signal = signal
        self.signal?.count = count!
    }
}
