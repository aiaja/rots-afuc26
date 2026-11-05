import SwiftUI

struct ContentView: View {
    @State var modalEdit: Bool = false
    @State var deletealert: Bool = false
    var body: some View {
        NavigationStack {
            ZStack {
              
                Color(.systemPink)
                    .opacity(0.12)
                    .ignoresSafeArea()
                
               
                VStack {
                    Spacer()
                    BottomCurveView()
                        .fill(Color(.systemPink).opacity(0.25))
                        .frame(height: 140)
                        .ignoresSafeArea(edges: .bottom)
                }
                
            
                VStack(spacing: 20) {
                    
                    // MARK: - STICKY NOTE
                    VStack(spacing: 0) {
                        Rectangle()
                            .fill(Color.brown.opacity(0.6))
                            .frame(width: 14, height: 22)
                            .cornerRadius(4)
                            .zIndex(1)
                            .offset(y: 10)
                        
                        ZStack(alignment: .bottomTrailing) {
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Text....")
                                    .font(.system(size: 16, weight: .regular))
                                    .foregroundColor(.black)
                                    .multilineTextAlignment(.leading)
                                Spacer(minLength: 0)
                            }
                            .padding(20)
                            .frame(maxWidth: .infinity) // Tinggi pas & proporsional
                            .background(DSColor.noteYellow)
                            .cornerRadius(16)
                            .shadow(color: Color.black.opacity(0.06), radius: 6, x: 0, y: 3)
                            
                            //TAMPILAN MOOD KANAN BAWAH NOTE
                            HStack {
                                Image("mood-amazing")
                                    .padding(16)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    
                    // Character & Balon Percakapan
                    HStack(alignment: .center, spacing: 12) {
                        Image("chick")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 90, height: 90)
                        
                        Text("You felt good this day.")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.primary)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .background(Color.white)
                            .cornerRadius(20)
                            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 3)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    
                    Spacer()
                }
            }
            .navigationTitle("Your Thought")
            .navigationBarTitleDisplayMode(.inline)
            
            
            //MARK: - TOOLS BAR
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {}) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.primary)
                            .padding(6)
                            
                          
                    }
                }
                
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button(action: {
                        modalEdit.toggle()
                    }) {
                        Image(systemName: "pencil")
                    }
                    Button(action: {
                        deletealert = true
                    }) {
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                            .padding(6)
                           
                    }
                }
            }
         
            
            
            //MARK: - ALERT
            .alert("Hapus Catatan", isPresented: $deletealert) {
                Button("Hapus", role: .destructive) {
                }
                Button("Batal", role: .cancel) {}
            } message: {
                Text("Apakah Anda yakin ingin menghapus catatan ini?")
            }
        }
    }
}

// MARK: - Elemen Lengkungan Bawah
struct BottomCurveView: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: 30))
        path.addQuadCurve(to: CGPoint(x: rect.width, y: 30),
                          control: CGPoint(x: rect.width / 2, y: -20))
        path.addLine(to: CGPoint(x: rect.width, y: rect.height))
        path.addLine(to: CGPoint(x: 0, y: rect.height))
        path.closeSubpath()
        return path
    }
}



#Preview {
    ContentView()
}
