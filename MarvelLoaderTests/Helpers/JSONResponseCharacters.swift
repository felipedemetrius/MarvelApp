//
//  JSONResponse.swift
//  MarvelLoaderTests
//
//  Created by Felipe Demetrius Martins da Silva on 29/05/24.
//

import Foundation

let jsonStringResponseCharacters = """
    {
        "data": {
        "results": [
          {
            "id": 1011334,
            "name": "3-D Man",
            "description": "",
            "modified": "2014-04-29T14:18:17-0400",
            "thumbnail": {
              "path": "http://i.annihil.us/u/prod/marvel/i/mg/c/e0/535fecbbb9784",
              "extension": "jpg"
            },
          },
          {
            "id": 2908310,
            "name": "3-D Man(Ultimate)",
            "description": "some description",
            "modified": "2014-04-30T14:18:17-0400",
            "thumbnail": {
              "path": "http://i.annihil.us/u/prod/marvel/i/mg/c/e0/535fecbbb9784",
              "extension": "jpg"
            },
          },
        ]
        }
    }
""".utf8
