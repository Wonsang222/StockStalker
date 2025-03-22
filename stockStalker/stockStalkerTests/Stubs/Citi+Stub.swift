//
//  Hana+Stub.swift
//  stockStalkerTests
//
//  Created by Wonsang Hwang on 3/21/25.
//

import Foundation
@testable import stockStalker

struct CitiBankResponseStub {
    static func getURL() -> String {
        return stockStalker.CitiBankAPI.url
    }
    
    static func getRetunString() -> String {
        return """
'<ul class="exchangeList"> \n      <li> \n       <div class="tit" role="text"> \n        <div>\n         <span class="flagUs" data-jex-ml="">미국</span> \n         <em class="unit">(USD)</em>\n        </div> \n        <div>\n         <span class="green">1,465.50</span>\n        </div> \n       </div> \n       <ul> \n        <li role="text"><span data-jex-ml="">현찰 살 때</span> <em>1,494.70</em></li> \n        <li role="text"><span data-jex-ml="">현찰 팔 때</span> <em>1,436.42</em></li> \n        <li role="text"><span data-jex-ml="">송금 보낼 때</span> <em>1,483.50</em></li> \n        <li role="text"><span data-jex-ml="">송금 받을 때</span> <em>1,447.60</em></li> \n       </ul> </li> \n      <li> \n       <div class="tit" role="text"> \n        <div>\n         <span class="flagCn" data-jex-ml="">중국</span> \n         <em class="unit">(CNY)</em>\n        </div> \n        <div>\n         <span class="green">201.86</span>\n        </div> \n       </div> \n       <ul> \n        <li role="text"><span data-jex-ml="">현찰 살 때</span> <em>217.10</em></li> \n        <li role="text"><span data-jex-ml="">현찰 팔 때</span> <em>186.77</em></li> \n        <li role="text"><span data-jex-ml="">송금 보낼 때</span> <em>208.98</em></li> \n        <li role="text"><span data-jex-ml="">송금 받을 때</span> <em>194.80</em></li> \n       </ul> </li> \n      <li> \n       <div class="tit" role="text"> \n        <div>\n         <span class="flagEu" data-jex-ml="">유럽</span> \n         <em class="unit">(EUR)</em>\n        </div> \n        <div>\n         <span class="green">1,584.94</span>\n        </div> \n        <em><span class="icoDecrease" data-jex-ml=""><span data-jex-ml="">하락</span>-1.61</span></em> \n       </div> \n       <ul> \n        <li role="text"><span data-jex-ml="">현찰 살 때</span> <em>1,620.48</em></li> \n        <li role="text"><span data-jex-ml="">현찰 팔 때</span> <em>1,549.56</em></li> \n        <li role="text"><span data-jex-ml="">송금 보낼 때</span> <em>1,604.75</em></li> \n        <li role="text"><span data-jex-ml="">송금 받을 때</span> <em>1,565.21</em></li> \n       </ul> </li> \n      <li> \n       <div class="tit" role="text"> \n        <div>\n         <span class="flagJp" data-jex-ml="">일본</span> \n         <em class="unit">(JPY)</em>\n        </div> \n        <div>\n         <span class="green">981.48</span>\n        </div> \n        <em><span class="icoDecrease" data-jex-ml=""><span data-jex-ml="">하락</span>-3.13</span></em> \n       </div> \n       <ul> \n        <li role="text"><span data-jex-ml="">현찰 살 때</span> <em>1,001.20</em></li> \n        <li role="text"><span data-jex-ml="">현찰 팔 때</span> <em>961.84</em></li> \n        <li role="text"><span data-jex-ml="">송금 보낼 때</span> <em>993.73</em></li> \n        <li role="text"><span data-jex-ml="">송금 받을 때</span> <em>969.28</em></li> \n       </ul> </li> \n     </ul>'
"""
    }
}
