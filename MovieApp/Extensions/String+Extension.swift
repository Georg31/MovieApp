//
//  String+Extension.swift
//  MovieApp
//
//  Created by George Digmelashvili on 7/22/21.
//

import UIKit
import Alamofire

extension String {
    func downloadImage(completion: @escaping (UIImage?) -> Void) {
        if self.isEmpty { completion(UIImage(named: "no-image"))} else {
            guard let url = URL(string: Constants.imgUrl + self) else {return}
            AF.request(url).response { resp in
                if case .success(let image) = resp.result {
                    completion(UIImage(data: image!))
                }
            }
        }
    }
}
