# DoRun


 pod 'DoRun',’~> 0.0.4'
 
 
 
    let doNow = DoNow()
     doNow.doRun("") { (classType,parameter,index) in 
       if sucess {
       //Perform some action, or send a value
         doNow.transfer(value: "")
       }else {
       //Jump to the main thread and send the value
         doNow.jumpToEnd(value: "")
       }
     }.doRunLoop(index: 10)          //Cycle to the previous step
     .doEnd("") { (classType, parameter, result) in  
      //Return to main thread Refresh UI
     }

or:

    doNow.doRun(pams) { (classType,parameter,index) in
      if sucess {
      //Perform some action, or send a value
        doNow.transfer(value: "")
      }else {
      //Jump to the main thread and send the value
        doNow.jumpToEnd(value: "")
      }
    }.doNext("") { (classType, parameter, result) in
     if sucess {
        doNow.transfer(value: "")
      }else {
        doNow.jumpToEnd(value: "")
      }
    }.doNext("") { (classType, parameter, result) in
      if sucess {
        doNow.transfer(value: "")
      }else {
        doNow.jumpToEnd(value: "")
      }
    }.doEnd(nil) { (classType, parameter, result) in
      //Return to main thread Refresh UI
    }
