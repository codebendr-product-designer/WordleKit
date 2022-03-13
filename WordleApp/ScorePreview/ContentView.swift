import SwiftUI
import WordleKit

extension WordleKit {
    struct ContentView: View {
        @ObservedObject var viewModel: AppViewModel
        
        public init(
            _ viewModel: AppViewModel
        ) {
            self.viewModel = viewModel
            dump($viewModel.scores.count)
            
        }
        
        public var body: some View {
            NavigationView {
                List(viewModel.scores) { score in
                    NavigationLink {
                        List(score.tries, id:\.self) {
                            Text($0)
                        }
                        
                    } label: {
                        Text(score.word).font(.largeTitle)
                    }
                }
                .navigationTitle("some data")
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        WordleKit.ContentView(
            .init(scoreClient: .live)
        )
    }
}
