# Searchers（他ジャンル検索アプリ）　　
＜ポイント＞  
・MVPアーキテクチャを採用  
・６つのwebAPIを用いた他ジャンル検索  
・Alamofire/CodableによるJSON解析  
・Alamofire/SwiftyJSONによるJSON解析  
・CoreLocationを用いた現在地表示/現在地からの検索機能  
・Realmを用いたお気に入り保存機能  


＜概要＞  
ネット通販、グルメ、宿の検索機能を１ツールに集約したアプリです  
<p>
<img src="https://user-images.githubusercontent.com/91421375/152862410-ba44163e-925a-4267-bf7a-241a73738304.png" width=180>&emsp;&emsp;
<img src="https://user-images.githubusercontent.com/91421375/152862705-dc6231fc-7ade-4750-bb15-20783e0c23d2.png" width=180>&emsp;&emsp;
<img src="https://user-images.githubusercontent.com/91421375/152862639-d9ce62e8-386a-48d8-b60c-a9ea62748d64.png" width=180>&emsp;&emsp;
<img src="https://user-images.githubusercontent.com/91421375/152862557-84c3284a-2e81-4ee6-81eb-e112fab24f50.png" width=180>
</p>  

# 目次  
- [使用技術](https://github.com/masappu/Searchers/tree/master#%E4%BD%BF%E7%94%A8%E6%8A%80%E8%A1%93)
- [機能一覧](https://github.com/masappu/Searchers/tree/master#%E6%A9%9F%E8%83%BD%E4%B8%80%E8%A6%A7)
- [設計](https://github.com/masappu/Searchers#%E8%A8%AD%E8%A8%88)


# 使用技術
- Xcode 13.2
- Swift 5.5.2
- iOS 15.2
- MVP

＜Pods＞  
- GoogleMaps
- GooglePlaces
- SwiftyJSON
- Alamofire
- SDWebImage
- RealmSwift

＜API＞  
- RECRUIT Web Service
  - グルメサーチAPI
  - ジャンルマスタAPI
- Rakuten Web Service
  - 楽天市場商品検索API
  - 楽天トラベル空室検索API
- Google Maps Platform
  - Maps SDK for iOS
  - Places SDK for iOS

# 機能一覧
- 検索機能
  - ネット通販（楽天市場）
  - グルメ検索（ホットペッパーグルメ）
  - 宿検索（楽天トラベル）
- 目的地検索
  - 目的地のキーワード検索
  - 検索範囲指定
- マップ表示
  - GoogleMap表示
  - 現在地情報の取得/表示
  - 検索結果のマーカー表示
- お気に入り保存機能

# 設計
画面遷移図

<img src="https://user-images.githubusercontent.com/91421375/152862742-00a3a174-a853-47c6-9660-8a290d22d47b.png" width=４００>

その他資料  
- [画面イベント定義書](https://docs.google.com/spreadsheets/d/18DRXvEmEQuNkz8gr_RiQoSqudhwqNlAA-f7Nf1lmhwU/edit?usp=sharing)
- [MVP実装における定義書](https://docs.google.com/spreadsheets/d/18DRXvEmEQuNkz8gr_RiQoSqudhwqNlAA-f7Nf1lmhwU/edit#gid=2067322156)
