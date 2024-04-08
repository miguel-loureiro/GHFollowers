//
//  GHFAvatarImageView.swift
//  GHFollowers
//
//  Created by António Loureiro on 05/03/2024.
//

import UIKit

class GHFAvatarImageView: UIImageView {

    let placeholderImage = UIImage(named: "avatar-placeholder")! //aqui fiz o force unwrap porque sei que tenho esta imagem nos assets
    let cache = NetworkManager.shared.cache

    override init(frame: CGRect) {

        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {

        layer.cornerRadius = 10
        clipsToBounds = true
        image = placeholderImage
        translatesAutoresizingMaskIntoConstraints = false
    }

    func downloadImage(from urlString: String) {

        let cacheKey = NSString(string: urlString)

        //se a imagem que vou fazer o download for igual à imagem que já tenho na cache então saio (return)
        if let image = cache.object(forKey: cacheKey) {

            self.image = image
            return
        }
        //se não tiver a imagem faço o processo de fazer o download da imagem
        //não se vai fazer o error handling pois isso iria ser um performance blocker
        //quando não for possivel fazer o download da imagem , vai aparecer a imagem de placeholder
        guard let url = URL(string: urlString) else { return }

        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in

            guard let self = self else { return }

            if error != nil { return }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {

                return
            }

            guard let data = data else { return }

            guard let image = UIImage(data: data) else { return }

            //aqui como já fiz o download da imagem vou então dar set à cache da imagem que fiz o download
            self.cache.setObject(image, forKey: cacheKey)

            //se alguma coisa falhar nesta network call faço return e saio
            //se tudo Ok então como já tenho a image, de seguida vou setar a avatarImage com esta image
            //como vou fazer um update à UI (e estou numa background thread) tenho que ir para a main thread

            DispatchQueue.main.async {

                self.image = image
            }
        }

        task.resume()
    }
}
