//
//  InitSettingView.swift
//  Moasa
//
//  Created by 지준용 on 2022/06/12.
//

import SwiftUI

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct InitSettingView: View {
    
    @Environment(\.managedObjectContext) var viewContext
    @Environment(\.presentationMode) var dismiss
    
    @State public var image: Data = .init(count: 1)
    @State public var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State public var show: Bool = false
    
    @State var targetName: String = ""
    @State var targetPrice: String = ""
    @State var fixedSaving: String = ""
    
    var body: some View {
        NavigationView {

        TabView {
            VStack {
                HStack {
                    Text("사고 싶은 물건 사진을 넣어주세요.")
                        .font(.system(size: 25, weight: .semibold))
                        .padding(.top, 90)
                    Spacer()
                }.padding(.leading, 16)

                if self.image.count != 1 {
                    Button(action: {
                        self.show.toggle()
                    }, label: {
                        Image(uiImage: UIImage(data: self.image)!)
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
                        Image(systemName: "photo.fill")
                            .resizable()
                            .clipShape(Circle())
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 190, height: 190)
                            .padding(.top, 50)
                    })
                }
                Spacer()
                if self.image.count != 1 {
                    NavigationLink(destination: BudgetContentView()) {
                        ZStack {
                            Rectangle()
                                .frame(width: 360, height: 60)
                                .cornerRadius(13)
                                .foregroundColor(.accentColor)
                            Text("다음")
                                .foregroundColor(.white)
                                .font(.system(size: 20, weight: .bold))
                        }
                    }.padding(.bottom, 40)
                } else {
                    NavigationLink(destination: BudgetContentView()) {
                        ZStack {
                            Rectangle()
                                .frame(width: 360, height: 60)
                                .cornerRadius(13)
                                .foregroundColor(.gray)
                                .opacity(0.2)
                            Text("다음에 할게요")
                                .foregroundColor(.gray)
                                .font(.system(size: 20, weight: .bold))
                        }
                    }.padding(.bottom, 40)
                }
            }.sheet(isPresented: self.$show, content: {
                ImagePicker(images: self.$image, show: self.$show, sourceType: self.sourceType)
            })

            VStack {
                HStack {
                    Text("사고 싶은 물건을 입력해주세요.")
                        .font(.system(size: 25, weight: .semibold))
                        .padding(.top, 90)
                    Spacer()
                }.padding(.leading, 16)

                TextField("예시: Airpods Max", text: self.$targetName)
                    .padding(.leading, 16)
                    .font(.system(size: 17, weight: .regular))
                    .padding(.top, 140)
                Divider()
                    .background(Color.accentColor)
                    .padding(.horizontal, 16)
                Spacer()
                NavigationLink(destination: BudgetContentView()) {
                    ZStack {
                        Rectangle()
                            .frame(width: 360, height: 60)
                            .cornerRadius(13)
                            .foregroundColor(self.targetName > "" ? .accentColor: .gray)
                            .opacity(self.targetName > "" ? 1 : 0.2)
                        Text(self.targetName > "" ? "다음" : "다음에 할게요")
                            .foregroundColor(self.targetName > "" ? .white: .gray)
                            .font(.system(size: 20, weight: .bold))
                    }
                }.padding(.bottom, 40)
            }

            VStack {
                HStack {
                    Text("물건 가격을 입력해주세요.")
                        .font(.system(size: 25, weight: .semibold))
                        .padding(.top, 90)
                    Spacer()
                }.padding(.leading, 16)
                HStack {
                    TextField("예시: " + numberFormatter(number: 1000000), text: self.$targetPrice)
                        .padding(.leading, 16)
                        .font(.system(size: 17, weight: .regular))
                        .keyboardType(.decimalPad)
                    Text("원")
                        .font(.system(size: 17, weight: .bold))
                        .padding(.trailing, 16)
                }.padding(.top, 140)
                Divider()
                    .background(Color.accentColor)
                    .padding(.horizontal, 16)
                Spacer()
                NavigationLink(destination: BudgetContentView()) {
                    ZStack {
                        Rectangle()
                            .frame(width: 360, height: 60)
                            .cornerRadius(13)
                            .foregroundColor(self.targetPrice > "" ? .accentColor: .gray)
                            .opacity(self.targetPrice > "" ? 1 : 0.2)
                        Text(self.targetPrice > "" ? "다음" : "다음에 할게요")
                            .foregroundColor(self.targetPrice > "" ? .white : .gray)
                            .font(.system(size: 20, weight: .bold))
                    }
                }.padding(.bottom, 40)
            }

            VStack {
                HStack {
                    Text("월 고정 저금액을 입력해주세요")
                        .font(.system(size: 25, weight: .semibold))
                        .padding(.top, 90)
                    Spacer()
                }.padding(.leading, 16)
                HStack {
                    TextField("예시: " + numberFormatter(number: 100000), text: self.$fixedSaving)
                        .padding(.leading, 16)
                        .font(.system(size: 17, weight: .regular))
                        .keyboardType(.decimalPad)
                    Text("원")
                        .font(.system(size: 17, weight: .bold))
                        .padding(.trailing, 16)
                }.padding(.top, 140)
                Divider()
                    .background(Color.accentColor)
                    .padding(.horizontal, 16)
                Spacer()
                NavigationLink(destination: BudgetContentView()) {
                    Button(action: {
                        let add = TargetItem(context: self.viewContext)
                        add.targetImage = self.image

                        try? self.viewContext.save()

                        self.dismiss.wrappedValue.dismiss()
                        self.image.count = 0
                    }, label: {
                        ZStack {
                            Rectangle()
                                .frame(width: 360, height: 60)
                                .cornerRadius(13)
                                .foregroundColor(self.fixedSaving > "" ? .accentColor : .gray)
                                .opacity(self.fixedSaving > "" ? 1 : 0.2)
                            Text(self.fixedSaving > "" ? "입력 완료": "다음에 할게요")
                                .foregroundColor(self.fixedSaving > "" ? .white : .gray)
                                .font(.system(size: 20, weight: .bold))
                        }
                    })
                }.padding(.bottom, 40)
            }
        }
        .tabViewStyle(PageTabViewStyle())
        .background(Color.kenCustomOrange)
        .navigationBarHidden(true)
        }.onTapGesture{
            hideKeyboard()
        }
    }
    func numberFormatter(number: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal

        return numberFormatter.string(from: NSNumber(value: number))!
    }
}

struct InitSettingView_Previews: PreviewProvider {
    static var previews: some View {
        InitSettingView()
    }
}
