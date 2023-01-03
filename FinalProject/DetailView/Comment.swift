//
//  CommentCell.swift
//  FinalProject
//
//  Created by li on 2022/12/19.
//

import Foundation
import SwiftUI
import SDWebImageSwiftUI

struct CommentCell: View {
    let comment: BookComment
    
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Avatar(url: comment.userPhoto, size: Drawing.avatarSize)
            VStack(alignment: .leading, spacing: 10) {
                Text(comment.nickName).foregroundColor(ThemeColor.dimGray).frame(height: Drawing.avatarSize, alignment: .center)
                Text(comment.text)
            }
        }.padding()
    }
    
    private struct Drawing {
        static let avatarSize = 35.0
    }
}

struct Avatar: View {
    let url: String
    var size: CGFloat?
    
    var body: some View {
        let content = WebImage(url: URL(string: url)).resizable().clipShape(Circle())
        if let size = size {
            content.frame(width: size, height: size)
        } else {
            content
        }
    }
}

struct CommentCell_Previews: PreviewProvider {
    static var previews: some View {
        CommentCell(comment: BookComment.mock(id: "0"))
    }
}
