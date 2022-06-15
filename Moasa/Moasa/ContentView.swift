//
//  ContentView.swift
//  Moasa
//
//  Created by Junyeong Park on 2022/06/10.
//

import CoreData
import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var index = 0
    static var getConsumedCategory: NSFetchRequest<ConsumedCategory> {
        let request: NSFetchRequest<ConsumedCategory> = ConsumedCategory.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \ConsumedCategory.challengeCycle, ascending: true)]
        return request
    }
    @FetchRequest(fetchRequest: getConsumedCategory)
    private var consumedCategory: FetchedResults<ConsumedCategory>

    static var getConsumedItem: NSFetchRequest<ConsumedItem> {
        let request: NSFetchRequest<ConsumedItem> = ConsumedItem.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \ConsumedItem.id, ascending: true)]
        return request
    }
    @FetchRequest(fetchRequest: getConsumedItem)
    private var consumedItems: FetchedResults<ConsumedItem>
    @FetchRequest(
        sortDescriptors:
            [NSSortDescriptor(keyPath: \TargetItem.id, ascending: true)], animation: .default)
    private var targetItem: FetchedResults<TargetItem>

    // 메인 뷰: CoreData -> 타겟 아이템 + 소비 항목 리턴
    var body: some View {
        NavigationView {
            List {
                ForEach(consumedItems) { item in
                    NavigationLink {
                        Text("Item at \(item.challengeCycle)")
                    } label: {
                        Text("Item at \(item.challengeCycle)")
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addCategory) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
            Text("Select an item")
        }
    }

    private func addCategory() {
        withAnimation {
            let newItem = ConsumedCategory(context: viewContext)
            newItem.id = UUID()
            newItem.consumedCategory = "CATEGORY"
            newItem.challengeCycle = Int64(index)
            newItem.consumedLimit = Int64(index * 100)
            index += 1
            // TODO: 정보 입력 함수 만들기 (초기 세팅/키보드)
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
        // Category 추가 함수
    }
    private func addItem() {
        withAnimation {
            let newItem = ConsumedItem(context: viewContext)
            newItem.id = UUID()
            newItem.consumedDate = Date()
            newItem.consumedPrice = 100
            newItem.challengeCycle = Int64(index)
            newItem.consumedCategory = "CATEGORY"
            newItem.consumedMemo = ""
            newItem.consumedName = "NAME"
            // 키보드 -> 정보 입력, consumedItem 생성
            // TODO: 위 코드는 viewContext에 저장되는 newItem인데, ConsumedItem은 저장하지 않아도 된다. 방법 고안 필요
            // For 문 or 필터링 -> 해당 카테고리 소비 아이템에 새로운 consumedItem 추가
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    private func addTargetItem() {
        withAnimation {
            let newItem = TargetItem(context: viewContext)
            newItem.id = UUID()
            newItem.challengeCycle = 0
            newItem.fixedSaving = 100
            newItem.startDate = Date()
            newItem.targetImage = nil
            newItem.targetPrice = 100
            // 초기 세팅 -> 정보 입력, TargetItem 생성
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    private func deleteCategory(offsets: IndexSet) {
        withAnimation {
            offsets.map { consumedCategory[$0]
            }.forEach(viewContext.delete)
        }
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error\(nsError), \(nsError.userInfo)")
        }
    }
    private func deleteTargetItem(offsets: IndexSet) {
        withAnimation {
            offsets.map { targetItem[$0]
            }.forEach(viewContext.delete)
        }
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    // TODO: 소비 아이템 삭제 -> consumedCategory 내부의 consumedItems 내부 배열의 '원소' 하나를 삭제해야 함
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { consumedItems[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.shared.container.viewContext
        return ContentView().environment(\.managedObjectContext, context)
        // Preview Context -> shared Context로 변경
    }
}
