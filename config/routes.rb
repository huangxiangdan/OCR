Ocr::Application.routes.draw do
  match "ocr" => "ocr#ocr"
  match "proxy" => "ocr#proxy"
  match "fast_ocr" => "ocr#jimu_ocr"
  match "open" => "ocr#open"
  match "context" => "ocr#context"
  root :to => "ocr#index"
end
