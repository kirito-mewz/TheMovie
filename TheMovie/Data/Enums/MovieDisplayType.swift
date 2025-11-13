//
//  MovieDisplayType.swift
//  TheMovie
//
//  Created by Kiyotaka Kirito on 13/11/2025.
//

import RealmSwift

enum MovieDisplayType: String, CaseIterable, PersistableEnum {
    case sliderMovies = "Slider Movies"
    case popularMovies = "Popular Movies"
    case popularSeries = "Popular Series"
    case showcaseMovies = "Showcase Movies"
    case similarMoves = "Similar Movies"
    case movieWithGenres = "Actor Movies"
    case others = "Others"
}
