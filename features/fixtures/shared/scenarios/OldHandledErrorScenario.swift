class OldHandledErrorScenario: Scenario {
    
    override func startBugsnag() {
        modifyEventCreationDate()
        config.autoTrackSessions = false
        config.enabledErrorTypes.ooms = false
        super.startBugsnag()
    }
    
    override func run() {
        Bugsnag.notifyError(NSError(domain: "", code: 0, userInfo: nil))
    }
    
    func modifyEventCreationDate() {
        let dir = [NSSearchPathForDirectoriesInDomains(.applicationSupportDirectory, .userDomainMask, true)[0],
                   "com.bugsnag.fixtures.Bugsnag",
                   Bundle.main.bundleIdentifier!,
                   "v1",
                   "events"].joined(separator: "/")
        
        let creationDate = Calendar(identifier: .gregorian).date(byAdding: .day, value: -61, to: Date())!
        
        do {
            for name in try FileManager.default.contentsOfDirectory(atPath: dir) {
                let file = (dir as NSString).appendingPathComponent(name)
                try FileManager.default.setAttributes([.creationDate: creationDate], ofItemAtPath: file)
                NSLog("OldCrashReportScenario: Updated creation date of \((file as NSString).lastPathComponent) to \(creationDate)")
            }
        } catch {
            NSLog("\(error)")
        }
    }
}
