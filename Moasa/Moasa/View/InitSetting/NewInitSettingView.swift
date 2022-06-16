//
//  InitSettingView(Toss).swift
//  Moasa
//
//  Created by 지준용 on 2022/06/13.
//

import SwiftUI

struct NewInitSettingView: View {
//    @Environment(\.managedObjectContext) var viewContext
    @Environment(\.presentationMode) var dismiss

    @State private var showText = false
    @State private var showTargetImg = false

    @State var show = false
    @State var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State var image: Data? = nil

    @State var targetName: String = ""
    @State var targetPrice: Int64 = 0
    
    var titleArray: [String] = ["사고 싶은 물건을 입력해주세요", "물건 가격을 입력해주세요", "사고싶은 물건 사진을 넣어주세요"]
    @State var arrayCount: Int = 0
    
    @State var lastInput: Bool = false
    @State var nextView: Bool? = false

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Text(titleArray[arrayCount])
                        .font(.system(size: 25, weight: .semibold))
                        .padding(.top, 90)
                    Spacer()
                }.padding(.leading, 16)

                if showTargetImg {
                    if image == nil {
                        Button(action: {
                            self.show.toggle()
                        }, label: {
                            Image(systemName: "photo.fill")
                                .resizable()
                                .clipShape(Circle())
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 190, height: 190)
                                .padding(.top, 50)
                        })
                    } else {
                        Button(action: {
                            self.show.toggle()
                        }, label: {
                            Image(uiImage: UIImage(data: self.image!)!)
                                .resizable()
                                .clipShape(Circle())
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 190, height: 190)
                                .padding(.top, 50)
                        })
                    }
                }
                if showText {
                    HStack {
//                        TextField("예시: " + numberFormatter(number: 1_000_000), text: String(self.targetPrice))
                        TextField("예시: " + numberFormatter(number: 1_000_000),
                                  value: $targetPrice, formatter: NumberFormatter())
                            .padding(.leading, 16)
                            .font(.system(size: 17, weight: .regular))
                            .keyboardType(.decimalPad)
                        Text("원")
                            .font(.system(size: 17, weight: .bold))
                            .padding(.trailing, 16)
                    }
                    Divider()
                        .background(Color.accentColor)
                        .padding(.horizontal, 16)
                        .padding(.bottom, 20)
                }
                TextField("예시: Airpods Max", text: self.$targetName)
                    .padding(.leading, 16)
                    .font(.system(size: 17, weight: .regular))
                Divider()
                    .background(Color.accentColor)
                    .padding(.horizontal, 16)
                Spacer()

                // 저장한 뒤에 다음 페이지로 넘어가야 한다.
                if lastInput && self.targetPrice > 0 && !targetName.isEmpty {
                    NavigationLink(destination: MainView(), tag: true, selection: $nextView) {
                        EmptyView()
                    }
                    Button(action: {
                        
//                        withAnimation {
//                            let newItem = TargetItem(context: viewContext)
//                            newItem.id = UUID()
//                            newItem.challengeCycle = 0
//                            newItem.fixedSaving = 100
//                            newItem.startDate = Date()
//                            newItem.targetImage = image
//                            newItem.targetPrice = targetPrice
//                            newItem.targetName = targetName
//                            newItem
//                            // 초기 세팅 -> 정보 입력, TargetItem 생성
//                            do {
//                                try viewContext.save()
//                            } catch {
//                                let nsError = error as NSError
//                                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//                            }
                        nextView = true
                        }
                        
//                        let add = TargetItem(context: viewContext)
//                        add.id = UUID()
//                        add.targetName = targetName
//                        add.targetPrice = targetPrice
//                        add.targetImage = image
//                        add.challengeCycle = 0
//                        add.fixedSaving = 0
//                        add.startDate = Date()
//                        try? self.viewContext.save()
//                        nextView = true
//                        print("저장 완료")
                    , label: {
                        ZStack {
                            Rectangle()
                                .frame(width: 360, height: 60)
                                .cornerRadius(13)
                                .foregroundColor(.accentColor)
                            Text("이미지 저장하기")
                                .foregroundColor(.white)
                                .font(.system(size: 20, weight: .bold))
                        }
                    })
//                    NavigationLink(destination: Text("destination"), label: {
//                        ZStack {
//                            Button(action: {
//                                let add = TargetItem(context: viewContext)
//                                add.id = UUID()
//                                add.targetName = targetName
//                                add.targetPrice = targetPrice
//                                add.targetImage = image
//                                add.challengeCycle = 0
//                                add.fixedSaving = 0
//                                add.startDate = Date()
//
//                                try? self.viewContext.save()
//                                print("저장 완료")
//
//
//                            }, label: {
//                                ZStack {
//                                    Rectangle()
//                                        .frame(width: 360, height: 60)
//                                        .cornerRadius(13)
//                                        .foregroundColor(.accentColor)
//                                    Text("이미지 저장하기")
//                                        .foregroundColor(.white)
//                                        .font(.system(size: 20, weight: .bold))
//                                }
//                            })
//                        }
//                    }
                } else if !lastInput && self.targetPrice > 0 && !self.targetName.isEmpty {
                    Button(action: {
                        showTargetImg = true
                        lastInput = true
                        arrayCount += 1
                    }, label: {
                        ZStack {
                            Rectangle()
                                .frame(width: 360, height: 60)
                                .cornerRadius(13)
                                .foregroundColor(.accentColor)
                            Text("확인")
                                .foregroundColor(.white)
                                .font(.system(size: 20, weight: .bold))
                        }
                    }).opacity(self.arrayCount < 2 ? 1: 0)
                } else if !self.targetName.isEmpty {
                    Button(action: {
                        showText = true
                        arrayCount += 1
                    }, label: {
                        ZStack {
                            Rectangle()
                                .frame(width: 360, height: 60)
                                .cornerRadius(13)
                                .foregroundColor(.accentColor)
                            Text("확인")
                                .foregroundColor(.white)
                                .font(.system(size: 20, weight: .bold))
                        }
                    }).opacity(self.arrayCount < 1 ? 1: 0)
                }
            }
            .sheet(isPresented: self.$show, content: {
                ImagePicker(images: $image, show: self.$show, sourceType: self.sourceType)
            })
        }.background(Color.kenCustomOrange)
            .navigationBarHidden(true)
    }
}
