/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2020C
  Assessment: Assignment 1
  Author: Le Ngoc Danh
  ID: s3747380
  Created  date: 10/11/2020
  Last modified: 15/11/2020
  Acknowledgement: Acknowledge the resources that you use here.
  1. Stack Overflow, <https://stackoverflow.com/questions/28219848/how-to-download-file-in-swift>
  2. Emojis in Unicode list, <https://unicode.org/emoji/charts/full-emoji-list.html>
  3. Swift Documentation, <https://docs.swift.org/swift-book/LanguageGuide/TheBasics.html>
  4. Swift Documentation, <https://developer.apple.com/documentation/swift>
*/

import Foundation

//Data Structure: Dictionary [teamName: [MP,W,D,L,GF,GA,GD,PTS,R1,R2,R3,R4,R5]]
var teamsAndResults = Dictionary<String, Array<Int>>()


// link to get csv: https://fixturedownload.com/download/epl-2020-GMTStandardTime.csv
//from link, download into string
let csvLink = try String(contentsOf: URL(string: "https://fixturedownload.com/download/epl-2020-GMTStandardTime.csv")!)

//split Strings into array of lines
let lineArray = csvLink.split(separator: "\r\n")
var duplicateCheckSet = Set<String>() // check for duplicate team names

func extractData(){
    //start of data handle loop
    var counter = 0
    for lines in lineArray {
        switch counter {
        case 0:
            counter += 1
        case 1: // print data
            // start of case 1
            let segments = lines.split(separator: ",")
            var homeTeamName = ""
            var awayTeamName = ""
            var cCounter = 0
            for eachSegments in segments{
                if (cCounter == 3){ // set team names
                    if !duplicateCheckSet.contains(String(eachSegments)){
                        duplicateCheckSet.insert(String(eachSegments))
                        teamsAndResults[String(eachSegments)] = [0,0,0,0,0,0,0,0,-4,-4,-4,-4,-4]
                    }
                    homeTeamName = String(eachSegments)
                }
                if (cCounter == 4){ // set team names
                    if !duplicateCheckSet.contains(String(eachSegments)){
                        duplicateCheckSet.insert(String(eachSegments))
                        teamsAndResults[String(eachSegments)] = [0,0,0,0,0,0,0,0,-4,-4,-4,-4,-4]
                    }
                    awayTeamName = String(eachSegments)
                }
                if (cCounter == 5){ // handling results
                    let teamScores = eachSegments.split(separator: "-")
                    var homeTeamScore = 0
                    var awayTeamScore = 0
                    var ccCounter = 0
                    for goals in teamScores { //convert result as String to Int
                        let recordingGoals = Int(String(goals.trimmingCharacters(in: .whitespacesAndNewlines))) ?? 0
                        //get homeTeam and awayTeam score
                        if (ccCounter == 0) {
                            homeTeamScore = recordingGoals
                        }
                        else{
                            awayTeamScore = recordingGoals
                        }
                        ccCounter += 1
                    }
                    // Updating score. NOTE: -1 = WIN ✅ ; -2 = DRAW ➖ ; -3 = LOSE ❌ ; -4 = NOT PLAY ❓
                    //Example: [MP,W,D,L,GF,GA,GD,PTS,R1,R2,R3,R4,R5]
                    //Indexing [0, 1,2,3,4 ,5 ,6 , 7 ,8 ,9 ,10,11,12]
                    if var element = teamsAndResults[homeTeamName]{
                        element[0] += 1 // MP + 1
                        //Move last match result back by one element
                        element[12] = element [11] // 12 => 11
                        element[11] = element [10] // 11 => 10
                        element[10] = element [9]  // 10 => 9
                        element[9] = element [8]   // 9  => 8
                        if homeTeamScore > awayTeamScore{
                            element[1] += 1 // homeTeam wins + 1
                            element[7] += 3 // homeTeam Pts + 3
                            element[8] = -1 // homeTeam win this round ✅
                        }
                        else if homeTeamScore == awayTeamScore{
                            element[2] += 1 // draw + 1
                            element[7] += 1 // homeTeam Pts + 1
                            element[8] = -2 // homeTeam draw this round ➖
                        }
                        else{
                            element[3] += 1 //loss + 1
                            element[8] = -3 // homeTeam lose this round ❌
                        }
                        element[4] += homeTeamScore //GF +
                        element[5] += awayTeamScore //GA +
                        element[6] = abs(element[4] - element[5]) // GD
                        teamsAndResults[homeTeamName] = element // save changes to dictionary
                    }
                    if var element = teamsAndResults[awayTeamName]{
                        element[0] += 1 //MP + 1
                        //Move last match result back by one element
                        element[12] = element [11] // 12 => 11
                        element[11] = element [10] // 11 => 10
                        element[10] = element [9]  // 10 => 9
                        element[9] = element [8]   // 9  => 8
                        if homeTeamScore < awayTeamScore{
                            element[1] += 1 // awayTeam wins + 1
                            element[7] += 3 // awayTeam Pts + 3
                            element[8] = -1 // awayTeam win this round ✅
                        }
                        else if homeTeamScore == awayTeamScore{
                            element[2] += 1 // draw + 1
                            element[7] += 1 // awayTeam Pts + 1
                            element[8] = -2 // awayTeam draw this round ➖
                        }
                        else{
                            element[3] += 1 //loss + 1
                            element[8] = -3 // awayTeam lose this round ❌
                        }
                        element[4] += awayTeamScore // GF +
                        element[5] += homeTeamScore // GA +
                        element[6] = abs(element[4] - element[5]) // GD
                        teamsAndResults[awayTeamName] = element // save changes to dictionary
                    }
                    cCounter = 0
                }
                    cCounter += 1
                }
            // end of case 1
        default:
            print("Ignore this")
        }
    }
    //end of data handle loop
}

//display CSV function
func displayCSVData(){
    print("Selected: Display CSV Data")
    print("*\n*\n*")
    var counter = 0
    for lines in lineArray {
        switch counter {
        case 0: // print column names
            let segments = lines.split(separator: ",")
            for eachSegments in segments{
                    let s = String(eachSegments).padding(toLength: 20, withPad: " ", startingAt: 0)
                    print(s,terminator: " ")
                }
            print("")
            counter += 1
        case 1: // print data
            // start of case 1
            let segments = lines.split(separator: ",")
            for eachSegments in segments{
                let s = String(eachSegments).padding(toLength: 20, withPad: " ", startingAt: 0)
                print(s,terminator: " ")
            }
            print("")
        default:
            print("Ignore this")
        }
    }
    print("*\n*\n*")
    menuDisplay()
}

//Display result function
func displayResults(){
    print("Selected: Display EPL results")
    print("*\n*\n*")
    //display result
    print("  Club              ","  MP"," W","  D","  L"," GF"," GA"," GD","PTS", "       Last 5")
    var rankCounter = 1
    for (keys,values) in teamsAndResults{
        var teamPrinted = false
        let newKey = String(keys)
        for value in values{
            if !teamPrinted{
                print(String(format: "%3d", rankCounter), newKey.padding(toLength: 15, withPad: " ", startingAt: 0),String(format: "%4d", value),terminator: "")
                teamPrinted = true
            }
            else{
                switch value{
                case -4:
                    print("  ", terminator: "")
                    let questionMarkSign = "\u{2753}" // ❓
                    print(String(format: "%@", questionMarkSign),terminator: "")
                case -3:
                    print("  ", terminator: "")
                    let crossSign = "\u{274c}" //  ❌
                    print(String(format: "%@", crossSign),terminator: "")
                case -2:
                    print("  ", terminator: "")
                    let minusSign = "\u{2796}"  //  ➖
                    print(String(format: "%@", minusSign),terminator: "")
                case -1:
                    print("  ", terminator: "")
                    let checkSign = "\u{2705}"  // ✅
                    print(String(format: "%@", checkSign),terminator: "")
                default:
                    print(String(format: "%4d", value),terminator: "")
                }
            }
        }
        print("")
        rankCounter += 1
    }
    print("*\n*\n*")
    menuDisplay()
}

//Display result function highest to lowest
func displayResultHighestToLowest(){
    print("Selected: Display EPL results, highest ranking team to lowest")
    print("*\n*\n*")
    //sort result by points, descending
    let sortedResultBoard = teamsAndResults.sorted{ (first, second) -> Bool in
        return first.value[7] > second.value[7]
    }
    //display results
    print("  Club              ","MP"," W","  D","  L"," GF"," GA"," GD","PTS", "       Last 5")
    var rankCounter = 1
    for (keys,values) in sortedResultBoard{
        var teamPrinted = false
        let newKey = String(keys)
        for value in values{
            if !teamPrinted{
                print(String(format: "%3d", rankCounter), newKey.padding(toLength: 15, withPad: " ", startingAt: 0),String(format: "%4d", value),terminator: "")
                teamPrinted = true
            }
            else{
                switch value{
                case -4:
                    print("  ", terminator: "")
                    let questionMarkSign = "\u{2753}" // ❓
                    print(String(format: "%@", questionMarkSign),terminator: "")
                case -3:
                    print("  ", terminator: "")
                    let crossSign = "\u{274c}" //  ❌
                    print(String(format: "%@", crossSign),terminator: "")
                case -2:
                    print("  ", terminator: "")
                    let minusSign = "\u{2796}"  //  ➖
                    print(String(format: "%@", minusSign),terminator: "")
                case -1:
                    print("  ", terminator: "")
                    let checkSign = "\u{2705}"  // ✅
                    print(String(format: "%@", checkSign),terminator: "")
                default:
                    print(String(format: "%4d", value),terminator: "")
                }
            }
        }
        print("")
        rankCounter += 1
    }
    print("*\n*\n*")
    menuDisplay()
}

//Display result lowest to highest
func displayResultLowestToHighest(){
    print("Selected: Display EPL results, lowest ranking to highest")
    print("*\n*\n*")
    //sort result by points, ascending
    let sortedResultBoard = teamsAndResults.sorted{ (first, second) -> Bool in
        return first.value[7] < second.value[7]
    }
    //display results
    print("  Club                ","  MP"," W","  D","  L"," GF"," GA"," GD","PTS", "       Last 5")
    var rankCounter = 1
    for (keys,values) in sortedResultBoard{
        var teamPrinted = false
        let newKey = String(keys)
        for value in values{
            if !teamPrinted{
                print(String(format: "%3d", rankCounter), newKey.padding(toLength: 15, withPad: " ", startingAt: 0),String(format: "%4d", value),terminator: "")
                teamPrinted = true
            }
            else{
                switch value{
                case -4:
                    print("  ", terminator: "")
                    let questionMarkSign = "\u{2753}" // ❓
                    print(String(format: "%@", questionMarkSign),terminator: "")
                case -3:
                    print("  ", terminator: "")
                    let crossSign = "\u{274c}" //  ❌
                    print(String(format: "%@", crossSign),terminator: "")
                case -2:
                    print("  ", terminator: "")
                    let minusSign = "\u{2796}"  //  ➖
                    print(String(format: "%@", minusSign),terminator: "")
                case -1:
                    print("  ", terminator: "")
                    let checkSign = "\u{2705}"  // ✅
                    print(String(format: "%@", checkSign),terminator: "")
                default:
                    print(String(format: "%4d", value),terminator: "")
                }
            }
        }
        print("")
        rankCounter += 1
    }
    print("*\n*\n*")
    menuDisplay()
}

//Menu display function
func menuDisplay(){
    print("Welcome to EPL Result Display Board Program")
    print("1. Display CSV data")
    print("2. Display EPL results")
    print("3. Display EPL results, highest ranking team to lowest")
    print("4. Display EPL results, lowest ranking team to highest")
    print("5. Exit")
    print("Please enter your choice: ", terminator: "")
    let menuInput = readLine()
    switch menuInput {
    case "1":
        displayCSVData()
    case "2":
        displayResults()
    case "3":
        displayResultHighestToLowest()
    case "4":
        displayResultLowestToHighest()
    case "5":
        print("*\n*\n*")
        print("Exitting program.")
    default:
        print("*\n*")
        print("Input is invalid. Please try again.")
        print("*\n*")
        menuDisplay()
    }
}

//main
extractData()
menuDisplay()
