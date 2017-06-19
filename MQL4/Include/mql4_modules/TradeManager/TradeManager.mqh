//+------------------------------------------------------------------+
//|                                                      OnTrade.mqh |
//|                                 Copyright 2017, Keisuke Iwabuchi |
//|                                        https://order-button.com/ |
//+------------------------------------------------------------------+
#property strict


#ifndef _LOAD_MODULE_ON_TRADE
#define _LOAD_MODULE_ON_TRADE


#include <mql4_modules\OrderData\OrderData.mqh>


/** OnTradeを擬似的に再現するためのクラス */
class TradeManager
{
   private:
      static OrderData positons[];
      
      static bool checkPositions(void);
      static void setPositions(void);
      
   public:
      static void Init(void);
      static void Run(void);
};


/** @var OrderData postions[] 保有中の各オーダー情報を保持する配列 */
static OrderData TradeManager::positons[] = {};


/**
 * 保有中オーダーの変化の有無を検査する
 *
 * @return bool true:変化なし, false: 変化あり
 */
static bool TradeManager::checkPositions(void)
{
   if(ArraySize(TradeManager::positons) != OrdersTotal()) {
      Print("aaa");
      return(false);
   }
   for(int i = OrdersTotal() - 1; i >= 0; i--) {
      if(!OrderSelect(i, SELECT_BY_POS)) {
         Print("bbb");
         return(false);
      }
      if(TradeManager::positons[i].ticket     != OrderTicket())      return(false);
      if(TradeManager::positons[i].symbol     != OrderSymbol())      return(false);
      if(TradeManager::positons[i].type       != OrderType())        return(false);
      if(TradeManager::positons[i].lots       != OrderLots())        return(false);
      if(TradeManager::positons[i].open_time  != OrderOpenTime())    return(false);
      if(TradeManager::positons[i].open_price != OrderOpenPrice())   return(false);
      if(TradeManager::positons[i].stoploss   != OrderStopLoss())    return(false);
      if(TradeManager::positons[i].takeprofit != OrderTakeProfit())  return(false);
      if(TradeManager::positons[i].expiration != OrderExpiration())  return(false);
      if(TradeManager::positons[i].comment    != OrderComment())     return(false);
      if(TradeManager::positons[i].magic      != OrderMagicNumber()) return(false);
   }
   
   return(true);
}


/** positionsに保有中のオーダー情報を登録する */
static void TradeManager::setPositions(void)
{
   int size = OrdersTotal();
   ArrayResize(TradeManager::positons, size);
   for(int i = size - 1; i >= 0; i--) {
      if(!OrderSelect(i, SELECT_BY_POS)) {
         Print("ng");
         return;
      }
      TradeManager::positons[i].ticket     = OrderTicket();
      TradeManager::positons[i].symbol     = OrderSymbol();
      TradeManager::positons[i].type       = OrderType();
      TradeManager::positons[i].lots       = OrderLots();
      TradeManager::positons[i].open_time  = OrderOpenTime();
      TradeManager::positons[i].open_price = OrderOpenPrice();
      TradeManager::positons[i].stoploss   = OrderStopLoss();
      TradeManager::positons[i].takeprofit = OrderTakeProfit();
      TradeManager::positons[i].expiration = OrderExpiration();
      TradeManager::positons[i].comment    = OrderComment();
      TradeManager::positons[i].magic      = OrderMagicNumber();
   }
}


/** postionsを初期化する */
static void TradeManager::Init(void)
{
   TradeManager::setPositions();
}


/** 
 * 実行関数
 * オーダーの変化をチェックし、変化していた場合はpositionsを再計算してOnTickを実行
 */
static void TradeManager::Run(void)
{
   if(!TradeManager::checkPositions()) {
      TradeManager::setPositions();
      OnTrade();
   }
}


#endif
