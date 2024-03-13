//
//  MemoStorageType.swift
//  Boopee
//
//  Created by yunjikim on 3/13/24.
//

import UIKit
import RxSwift

protocol MemoStorageType {
    func createMemo(memo: Memo) -> Observable<Memo>
    func readMemo() -> Observable<[Memo]>
    func updateMemo(memo: Memo) -> Observable<[Memo]>
    func deleteMemo(memo: Memo) -> Observable<[Memo]>
}
