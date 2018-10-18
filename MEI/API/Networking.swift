//
//  Networking.swift
//  MEI
//
//  Created by Alex Lavrinenko on 17.06.2018.
//

import Foundation
import Alamofire
import ObjectMapper

struct Networking {
	static func postRequest<ResultType: ImmutableMappable>
		(_ api: APIMethodProtocol,
		 success: @escaping ((_ result: ResultType) -> Void),
		 error: @escaping ((_ error: Error) -> Void)) {
		Alamofire.upload(multipartFormData: api.multipartData, usingThreshold: UInt64(),
										 to: api.path, method: api.method, headers: nil,
										 encodingCompletion: { (encodingResult) in
											switch encodingResult {
											case .success(let upload, _, _):
												#if DEBUG
												upload.responseString(completionHandler: { (response) in
													print(response)
												})
												#endif
												
												let req = upload.responseObject(completionHandler: { (response: DataResponse<ResultType>) in
													guard let result = response.value else {
														error(NetworkError.mappingError)
														return
													}
													success(result)
												})
												
												debugPrint(req)
											case .failure:
												error(NetworkError.mappingError)
												return
											}
		})
	}
	
	static func postRequestString
		(_ api: APIMethodProtocol,
		 success: @escaping ((_ result: String) -> Void),
		 error: @escaping ((_ error: Error) -> Void)) {
		Alamofire.upload(multipartFormData: api.multipartData, usingThreshold: UInt64(),
										 to: api.path, method: api.method, headers: nil,
										 encodingCompletion: { (encodingResult) in
											switch encodingResult {
											case .success(let upload, _, _):
												let req = upload.responseString(completionHandler: { (response) in
													print(response)
												})
												debugPrint(req)
											case .failure:
												error(NetworkError.mappingError)
												return
											}
		})
	}
}
