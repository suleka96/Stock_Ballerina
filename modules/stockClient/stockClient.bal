import ballerina/http;
import ballerina/io;
import ballerina/time;
import stock_data.tabular as tabular;

configurable string apiKey = ?;
string date = time:utcToString(time:utcNow()).substring(0, 10);

type AllStockData record {|
    string open;
    string high;
    string low;
    string close;
    string volume;
|};
AllStockData[] stockData = [];

public function main() returns @tainted  error? {
    
string searchSymbol = io:readln("Insert stock search symbol: ");
io:println("Stock Data Report of "+ searchSymbol.toUpperAscii()+ " - " + date);
io:println("Press ctrl + c to exit");

io:println("****OPTIONS******");
io:println("View All data: A");
io:println("View Selected data: B");
string option = io:readln("Insert Option: ");

match option {
      "A" => {  
          while true {
              check invokeWorker1(searchSymbol);
              displayInTabular();
              stockData.removeAll();
          }
      }
      "B" => {
          while true {
              check invokeWorker1(searchSymbol);
          }
      }
}


}

function selectedData() {

}

function invokeWorker1(string searchSymbol) returns error? {
    future<error?> worker1 = start getAllData(searchSymbol);
    check wait worker1;
}

function getAllData(string searchSymbol) returns error? {
    http:Client httpClient = check new ("https://www.alphavantage.co");
    json jsonPayload = check httpClient->get("/query?function=TIME_SERIES_INTRADAY&symbol="+searchSymbol.toUpperAscii()+"&interval=5min&apikey="+apiKey, targetType = json);

    map<json> allData = <map<json>>jsonPayload;
    map<json> metaData = <map<json>>allData["Meta Data"];

    io:println("Last Refreshed "+ metaData["3. Last Refreshed"].toString());
    io:println("Interval "+ metaData["4. Interval"].toString());

    foreach json item in <map<json>>allData["Time Series (5min)"] {
        map<json> stockItem = <map<json>>item;
        AllStockData stock = { 
            open: stockItem["1. open"].toString(), 
            high: stockItem["2. high"].toString(), 
            low:  stockItem["3. low"].toString(),
            close: stockItem["4. close"].toString(), 
            volume: stockItem["5. volume"].toString()
        };
        stockData.push(stock);
    }
}

function displayInTabular() {
    tabular:AddHeader("open", "high", "low", "close", "volume");
    foreach var item in stockData{
        tabular:AddLine(item["open"], item["high"], item["low"], item["close"], item["volume"]);
    }
}