//
//  Enumerations.swift
//  University Forum
//
//  Created by Ian Talisic on 11/11/2021.
//

import Foundation

enum Collection {
    static let Posts: String = "posts"
    static let Users: String = "users"
    static let Universities: String = "universities"
    static let Photos: String = "photos"
    static let Trainings: String = "training"
    static let AfterschoolSchedule: String = "groups"
    static let Task: String = "tasks"
    static let Announcement: String = "announcements"
}

enum SharedMessages {
    static let success: String = "Success!"
    static let successPostCreation: String = "You have successfully created a post. Your post is under review."
    static let failed: String = "Failed"
    static let failedPostCreation: String = "There was an error while creating your post. Please try again later."
}
