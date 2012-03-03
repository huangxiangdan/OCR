Ocr::Application.routes.draw do
  match "ocr" => "ocr#ocr"
  root :to => "ocr#index"
end
