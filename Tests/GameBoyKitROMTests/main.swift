import Foundation
import GameBoyKit

// Compare GameBoy state with dumps from binjgb (https://github.com/binji/binjgb).
//
// You probably do NOT want to enable this.
// But if you do, then:
// 1. Go to 'repository_root/ROMs'
// 2. Go to directory responsible for your test case (look for 'Tests' prefix)
// 3. Unzip 'Dump.zip'
//
// Also note that minor inconsistencies are ok, but you have to manually
// check each case.
let useDumps = false

//BootromTests.run(compareWithDumps: useDumps)

BlarggTests.cpuInstrs01(compareWithDumps: useDumps)
BlarggTests.cpuInstrs02(compareWithDumps: useDumps)
BlarggTests.cpuInstrs03(compareWithDumps: useDumps)
BlarggTests.cpuInstrs04(compareWithDumps: useDumps)
BlarggTests.cpuInstrs05(compareWithDumps: useDumps)
BlarggTests.cpuInstrs06(compareWithDumps: useDumps)
BlarggTests.cpuInstrs07(compareWithDumps: useDumps)
BlarggTests.cpuInstrs08(compareWithDumps: useDumps)
BlarggTests.cpuInstrs09(compareWithDumps: useDumps)
BlarggTests.cpuInstrs10(compareWithDumps: useDumps)
BlarggTests.cpuInstrs11(compareWithDumps: useDumps)
BlarggTests.instrTiming(compareWithDumps: useDumps)

//TetrisTest.run(compareWithDumps: ())

// Show single frame performance
//performanceTest()
