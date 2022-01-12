//
//  IngredientRow.swift
//  CosmeticChemicalDetection
//
//  Created by Pragatha on 10/4/21.
//

import SwiftUI

struct IngredientRow: View {
    var ingredient: Ingredient
    
    var body: some View {
        Text(ingredient.name)
       }
}

