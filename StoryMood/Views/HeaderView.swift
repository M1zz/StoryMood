import SwiftUI

struct HeaderView: View {
    let totalCount: Int
    let missingCount: Int
    let availableCount: Int
    @Binding var showMissingOnly: Bool
    @Binding var showTaleList: Bool
    
    var body: some View {
        VStack(spacing: 12) {
            // Title
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("이야기 무드")
                        .font(.system(size: 28, weight: .heavy, design: .rounded))
                    Text("Story Mood — 동화 사운드 보조도구")
                        .font(.system(size: 13, weight: .medium, design: .rounded))
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                // Tale list button
                Button {
                    showTaleList.toggle()
                } label: {
                    Image(systemName: "book.pages")
                        .font(.title3)
                        .foregroundStyle(.blue)
                        .padding(8)
                        .background(Circle().fill(.blue.opacity(0.1)))
                }
            }
            
            // Stats bar
            HStack(spacing: 16) {
                StatBadge(label: "전체", count: totalCount, color: .blue)
                StatBadge(label: "등록됨", count: availableCount, color: .green)
                StatBadge(label: "필요", count: missingCount, color: .red)
                
                Spacer()
                
                // Filter toggle
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        showMissingOnly.toggle()
                    }
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: showMissingOnly ? "line.3.horizontal.decrease.circle.fill" : "line.3.horizontal.decrease.circle")
                        Text(showMissingOnly ? "미등록만" : "필터")
                            .font(.system(size: 12, weight: .semibold))
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(
                        Capsule()
                            .fill(showMissingOnly ? Color.red.opacity(0.15) : Color(.tertiarySystemBackground))
                    )
                    .foregroundStyle(showMissingOnly ? .red : .secondary)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)
    }
}

// MARK: - Stat Badge

private struct StatBadge: View {
    let label: String
    let count: Int
    let color: Color
    
    var body: some View {
        VStack(spacing: 1) {
            Text("\(count)")
                .font(.system(size: 16, weight: .bold, design: .rounded))
                .foregroundStyle(color)
            Text(label)
                .font(.system(size: 10, weight: .medium))
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    HeaderView(
        totalCount: 150,
        missingCount: 150,
        availableCount: 0,
        showMissingOnly: .constant(false),
        showTaleList: .constant(false)
    )
}
