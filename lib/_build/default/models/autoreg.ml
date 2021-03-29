open Effppl.Diff.HMC

let autoreg obs_points ay () =
	let* alp = normal 0. 3. in 
	let* bet = normal 1. 1. in 

	for i = 0 to (obs_points-2) do 
		observe ((mk ay.(i+1)) -. alp -. bet*.(mk ay.(i))) (Effppl.Primitive.logpdf Effppl.Primitive.(normal 0. 2.))
	done ;
	(mk 1.)
;; 

let epochs = 10000 in
let ls = [1.0; 1.845946117493874; 2.4031367889696877; 5.213008219953643; 6.569541733525667; 9.96215742323023; 14.087626273739925; 16.949029368670313; 20.581132240245033; 22.630352573084505] in
 (* 9.96215742323023; 14.087626273739925; 16.949029368670313; 20.581132240245033; 22.630352573084505; 27.410358531830372; 34.849949932552434; 40.44846408178458; 45.39882407791218; 52.07451221034871; 57.88522050212809; 63.84887582346354; 70.6723005163203; 79.37808808936495; 91.58446979592769; 102.47649233587772; 116.20619552733064; 129.84095850734954; 143.64067783925742; 159.42934215699097; 177.75060637719707; 196.44189442021536; 216.46886740264688; 239.30693387103602; 263.5143634696501; 292.4166715741781; 324.0039386435021; 360.6196130410812; 398.828676766364; 442.60502199517714; 488.8624435450092; 539.6418194450135; 596.0233680163881; 656.0171049650055; 724.2790785798622; 797.5151958104506; 879.4720721658616; 970.1891518118284; 1069.7520615422563; 1179.9238547036505; 1300.7587686984475; 1433.585585854103; 1579.3328900436195; 1739.092646425595; 1914.2366020539528; 2108.298802612881; 2319.635015255823; 2555.044855675442; 2812.770758608618; 3097.25802866138; 3411.090426397609; 3752.897189447047; 4130.370346471203; 4546.6692089081; 5004.6637473571955; 5507.423086235643; 6059.651882435297; 6667.499688388186; 7337.465197348007; 8074.089272254728; 8883.530778664963; 9774.090311169371; 10753.763793748367; 11829.704765733317; 13015.388905037957; 14320.578337602097; 15754.381104062433; 17331.82248938065; 19066.39778329955; 20973.591993509028; 23073.2513514148; 25382.189665317317; 27923.322994846614; 30718.789804352396; 33792.4897865676; 37173.99992846252; 40891.9531617285; 44982.90285762446; 49482.45654793459; 54430.91386790184; 59874.39897081709; 65864.10353556537; 72452.87778677614; 79700.48673908044; 87673.43411162376; 96441.67014926043; 106088.50410854517; 116698.94010146229; 128370.8158877453; 141208.64631551114; 155330.80766711239; 170866.97550072183; 187955.63470288872; 206753.38967102105; 227427.76618740533; 250172.00689414324] in  *)
let ax = Array.of_list ls in 
let obs = Array.length ax in 
let fils = (hmc (autoreg obs ax) 2 0.0001 epochs) in

let mcl = List.map (fun ls -> (List.nth ls 0, List.nth ls 1)) fils in 
let sm =  List.map (fun (ax, _) -> ax) mcl in  
let sma =  Array.of_list sm in  
let sc =  List.map (fun (_, ay) -> ay) mcl in  
let sca =  Array.of_list sc in  

let mns = Owl_stats.mean sma in 
let mnc = Owl_stats.mean sca in
print_normal_list sm;
Printf.printf "%f %f \n" mns mnc; 