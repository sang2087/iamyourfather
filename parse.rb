require 'rexml/document'

str= %Q[<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" font-size="10px" font-family="sans-serif" fill="none" stroke="none" stroke-width="1.5" width="800" height="800">
  <g>
    <g>
      <a xlink:title="1">
        <circle fill="rgb(255,255,255)" stroke="rgb(31,119,180)" cx="400.0" cy="400.0" r="4.5"/>
      </a>
      <a xlink:title="n18">
        <circle fill="rgb(255,255,255)" stroke="rgb(31,119,180)" cx="412.90177838356027" cy="315.9848578258568" r="4.5"/>
      </a>
      <a xlink:title="n20">
        <circle fill="rgb(255,255,255)" stroke="rgb(31,119,180)" cx="237.49724400107613" cy="350.07150820669415" r="4.5"/>
      </a>
      <a xlink:title="n26">
        <circle fill="rgb(255,255,255)" stroke="rgb(31,119,180)" cx="171.6073401491382" cy="513.4098449264814" r="4.5"/>
      </a>
      <a xlink:title="n29">
        <circle fill="rgb(255,255,255)" stroke="rgb(31,119,180)" cx="155.24462033367533" cy="471.55280654449035" r="4.5"/>
      </a>
      <a xlink:title="n37">
        <circle fill="rgb(255,255,255)" stroke="rgb(31,119,180)" cx="145.71546976507375" cy="625.6975358376844" r="4.5"/>
      </a>
      <a xlink:title="n39">
        <circle fill="rgb(255,255,255)" stroke="rgb(31,119,180)" cx="97.51856140243893" cy="698.5464441321483" r="4.5"/>
      </a>
      <a xlink:title="n43">
        <circle fill="rgb(255,255,255)" stroke="rgb(31,119,180)" cx="110.82567251223338" cy="820.0930948277987" r="4.5"/>
      </a>
      <a xlink:title="n78">
        <circle fill="rgb(255,255,255)" stroke="rgb(31,119,180)" cx="62.62995126427228" cy="890.1086106324319" r="4.5"/>
      </a>
      <a xlink:title="n69">
        <circle fill="rgb(255,255,255)" stroke="rgb(31,119,180)" cx="37.022273682926766" cy="758.2557329585779" r="4.5"/>
      </a>
      <a xlink:title="n249">
        <circle fill="rgb(255,255,255)" stroke="rgb(31,119,180)" cx="-7.369636292838152" cy="833.6761227305935" r="4.5"/>
      </a>
      <a xlink:title="n296">
        <circle fill="rgb(255,255,255)" stroke="rgb(31,119,180)" cx="-38.97290297665921" cy="801.6563088664793" r="4.5"/>
      </a>
      <a xlink:title="n86">
        <circle fill="rgb(255,255,255)" stroke="rgb(31,119,180)" cx="4.824817176533259" cy="722.3919584611868" r="4.5"/>
      </a>
      <a xlink:title="n227">
        <circle fill="rgb(255,255,255)" stroke="rgb(31,119,180)" cx="-23.843430918252352" cy="683.648983899898" r="4.5"/>
      </a>
      <a xlink:title="n254">
        <circle fill="rgb(255,255,255)" stroke="rgb(31,119,180)" cx="-94.48400273796108" cy="730.9238145498811" r="4.5"/>
      </a>
      <a xlink:title="n146">
        <circle fill="rgb(255,255,255)" stroke="rgb(31,119,180)" cx="67.66078068626166" cy="664.9068577933288" r="4.5"/>
      </a>
      <a xlink:title="n44">
        <circle fill="rgb(255,255,255)" stroke="rgb(31,119,180)" cx="77.19556332010859" cy="506.75811753575454" r="4.5"/>
      </a>
      <a xlink:title="n65">
        <circle fill="rgb(255,255,255)" stroke="rgb(31,119,180)" cx="4.1213640255727455" cy="554.61276007829" r="4.5"/>
      </a>
      <a xlink:title="n143">
        <circle fill="rgb(255,255,255)" stroke="rgb(31,119,180)" cx="-75.05436316931275" cy="585.535312093948" r="4.5"/>
      </a>
      <a xlink:title="n172">
        <circle fill="rgb(255,255,255)" stroke="rgb(31,119,180)" cx="-138.70299171667068" cy="652.6342944168678" r="4.5"/>
      </a>
      <a xlink:title="n240">
        <circle fill="rgb(255,255,255)" stroke="rgb(31,119,180)" cx="-215.66056196190937" cy="688.7249079049917" r="4.5"/>
      </a>
      <a xlink:title="n185">
        <circle fill="rgb(255,255,255)" stroke="rgb(31,119,180)" cx="-167.33092082279177" cy="579.333840304509" r="4.5"/>
      </a>
      <a xlink:title="n253">
        <circle fill="rgb(255,255,255)" stroke="rgb(31,119,180)" cx="-248.37819522604775" cy="604.9529603480103" r="4.5"/>
      </a>
      <a xlink:title="n126">
        <circle fill="rgb(255,255,255)" stroke="rgb(31,119,180)" cx="-10.00178734700961" cy="511.9085982945793" r="4.5"/>
      </a>
      <a xlink:title="n76">
        <circle fill="rgb(255,255,255)" stroke="rgb(31,119,180)" cx="60.5083702146307" cy="418.58583615750905" r="4.5"/>
      </a>
      <a xlink:title="n128">
        <circle fill="rgb(255,255,255)" stroke="rgb(31,119,180)" cx="-24.36453723171161" cy="423.2322951968863" r="4.5"/>
      </a>
      <a xlink:title="n269">
        <circle fill="rgb(255,255,255)" stroke="rgb(31,119,180)" cx="-109.23744467805392" cy="427.8787542362636" r="4.5"/>
      </a>
      <a xlink:title="n280">
        <circle fill="rgb(255,255,255)" stroke="rgb(31,119,180)" cx="-192.45596673722855" cy="454.9629645984993" r="4.5"/>
      </a>
      <a xlink:title="n282">
        <circle fill="rgb(255,255,255)" stroke="rgb(31,119,180)" cx="-277.0925334139755" cy="462.8148166839992" r="4.5"/>
      </a>
      <a xlink:title="n288">
        <circle fill="rgb(255,255,255)" stroke="rgb(31,119,180)" cx="-194.91527059167163" cy="410.0409569682435" r="4.5"/>
      </a>
      <a xlink:title="n186">
        <circle fill="rgb(255,255,255)" stroke="rgb(31,119,180)" cx="64.18562317220466" cy="346.8144350809408" r="4.5"/>
      </a>
      <a xlink:title="n228">
        <circle fill="rgb(255,255,255)" stroke="rgb(31,119,180)" cx="-19.767971034744164" cy="333.51804385117606" r="4.5"/>
      </a>
      <a xlink:title="n38">
        <circle fill="rgb(255,255,255)" stroke="rgb(31,119,180)" cx="183.15884170899326" cy="265.81761639091906" r="4.5"/>
      </a>
      <a xlink:title="n58">
        <circle fill="rgb(255,255,255)" stroke="rgb(31,119,180)" cx="89.79690377429802" cy="260.8093426555221" r="4.5"/>
      </a>
      <a xlink:title="n94">
        <circle fill="rgb(255,255,255)" stroke="rgb(31,119,180)" cx="12.24612971787252" cy="226.01167831940265" r="4.5"/>
      </a>
      <a xlink:title="n260">
        <circle fill="rgb(255,255,255)" stroke="rgb(31,119,180)" cx="-65.30464433855298" cy="191.21401398328317" r="4.5"/>
      </a>
      <a xlink:title="n106">
        <circle fill="rgb(255,255,255)" stroke="rgb(31,119,180)" cx="137.0172476755174" cy="184.50041304021053" r="4.5"/>
      </a>
      <a xlink:title="n152">
        <circle fill="rgb(255,255,255)" stroke="rgb(31,119,180)" cx="57.47778551347335" cy="148.39806721083033" r="4.5"/>
      </a>
      <a xlink:title="n214">
        <circle fill="rgb(255,255,255)" stroke="rgb(31,119,180)" cx="-11.026657383831946" cy="98.07768065299643" r="4.5"/>
      </a>
      <a xlink:title="n207">
        <circle fill="rgb(255,255,255)" stroke="rgb(31,119,180)" cx="85.98646810936845" cy="113.60778329435817" r="4.5"/>
      </a>
      <a xlink:title="n45">
        <circle fill="rgb(255,255,255)" stroke="rgb(31,119,180)" cx="223.36743814425645" cy="216.08170810852735" r="4.5"/>
      </a>
      <a xlink:title="n105">
        <circle fill="rgb(255,255,255)" stroke="rgb(31,119,180)" cx="274.68709006005975" cy="177.91516350190764" r="4.5"/>
      </a>
      <a xlink:title="n153">
        <circle fill="rgb(255,255,255)" stroke="rgb(31,119,180)" cx="202.55723767537967" cy="123.20340391250568" r="4.5"/>
      </a>
      <a xlink:title="n295">
        <circle fill="rgb(255,255,255)" stroke="rgb(31,119,180)" cx="153.1965470942246" cy="54.00425489063207" r="4.5"/>
      </a>
      <a xlink:title="n184">
        <circle fill="rgb(255,255,255)" stroke="rgb(31,119,180)" cx="265.1464426188172" cy="87.88701074508288" r="4.5"/>
      </a>
      <a xlink:title="n233">
        <circle fill="rgb(255,255,255)" stroke="rgb(31,119,180)" cx="231.4330532735215" cy="9.858763431353566" r="4.5"/>
      </a>
      <a xlink:title="n53">
        <circle fill="rgb(255,255,255)" stroke="rgb(31,119,180)" cx="448.1249431017264" cy="236.9540253442128" r="4.5"/>
      </a>
      <a xlink:title="n133">
        <circle fill="rgb(255,255,255)" stroke="rgb(31,119,180)" cx="414.11838488261003" cy="145.3911407505495" r="4.5"/>
      </a>
      <a xlink:title="n134">
        <circle fill="rgb(255,255,255)" stroke="rgb(31,119,180)" cx="351.5001481854804" cy="63.47694822795626" r="4.5"/>
      </a>
      <a xlink:title="n195">
        <circle fill="rgb(255,255,255)" stroke="rgb(31,119,180)" cx="396.3342149929577" cy="60.019762309215764" r="4.5"/>
      </a>
      <a xlink:title="n264">
        <circle fill="rgb(255,255,255)" stroke="rgb(31,119,180)" cx="441.232402775702" cy="62.50942389254436" r="4.5"/>
      </a>
      <a xlink:title="n303">
        <circle fill="rgb(255,255,255)" stroke="rgb(31,119,180)" cx="485.4093638979897" cy="70.90238445327384" r="4.5"/>
      </a>
      <a xlink:title="n276">
        <circle fill="rgb(255,255,255)" stroke="rgb(31,119,180)" cx="526.401107210618" cy="178.53271100243748" r="4.5"/>
      </a>
      <a xlink:title="n304">
        <circle fill="rgb(255,255,255)" stroke="rgb(31,119,180)" cx="568.5348096141572" cy="104.71028133658331" r="4.5"/>
      </a>
      <a xlink:title="n67">
        <circle fill="rgb(255,255,255)" stroke="rgb(31,119,180)" cx="530.107973982675" cy="290.58375300658696" r="4.5"/>
      </a>
      <a xlink:title="n97">
        <circle fill="rgb(255,255,255)" stroke="rgb(31,119,180)" cx="595.1619609740125" cy="235.87562950988047" r="4.5"/>
      </a>
      <a xlink:title="n121">
        <circle fill="rgb(255,255,255)" stroke="rgb(31,119,180)" cx="645.1753762331111" cy="164.43889351390703" r="4.5"/>
      </a>
      <a xlink:title="n255">
        <circle fill="rgb(255,255,255)" stroke="rgb(31,119,180)" cx="674.117365242105" cy="198.8541074922822" r="4.5"/>
      </a>
      <a xlink:title="n107">
        <circle fill="rgb(255,255,255)" stroke="rgb(31,119,180)" cx="559.9088655141202" cy="342.3011721957281" r="4.5"/>
      </a>
      <a xlink:title="n261">
        <circle fill="rgb(255,255,255)" stroke="rgb(31,119,180)" cx="639.8632982711803" cy="313.45175829359215" r="4.5"/>
      </a>
      <a xlink:title="n170">
        <circle fill="rgb(255,255,255)" stroke="rgb(31,119,180)" cx="569.996233140951" cy="401.13168806985135" r="4.5"/>
      </a>
      <a xlink:title="n234">
        <circle fill="rgb(255,255,255)" stroke="rgb(31,119,180)" cx="654.9943497114265" cy="401.69753210477705" r="4.5"/>
      </a>
      <a xlink:title="n24">
        <circle fill="rgb(255,255,255)" stroke="rgb(31,119,180)" cx="479.76061090639075" cy="370.61896959194" r="4.5"/>
      </a>
      <a xlink:title="n62">
        <circle fill="rgb(255,255,255)" stroke="rgb(31,119,180)" cx="464.319854617255" cy="455.56938277518645" r="4.5"/>
      </a>
      <a xlink:title="n109">
        <circle fill="rgb(255,255,255)" stroke="rgb(31,119,180)" cx="546.1529471672982" cy="486.8292349057215" r="4.5"/>
      </a>
      <a xlink:title="n132">
        <circle fill="rgb(255,255,255)" stroke="rgb(31,119,180)" cx="619.2294207509472" cy="530.2438523585822" r="4.5"/>
      </a>
      <a xlink:title="n157">
        <circle fill="rgb(255,255,255)" stroke="rgb(31,119,180)" cx="692.3058943345962" cy="573.658469811443" r="4.5"/>
      </a>
      <a xlink:title="n201">
        <circle fill="rgb(255,255,255)" stroke="rgb(31,119,180)" cx="765.3823679182453" cy="617.0730872643037" r="4.5"/>
      </a>
      <a xlink:title="n209">
        <circle fill="rgb(255,255,255)" stroke="rgb(31,119,180)" cx="838.4588415018943" cy="660.4877047171644" r="4.5"/>
      </a>
      <a xlink:title="n135">
        <circle fill="rgb(255,255,255)" stroke="rgb(31,119,180)" cx="507.13077600893604" cy="531.9962000654684" r="4.5"/>
      </a>
      <a xlink:title="n289">
        <circle fill="rgb(255,255,255)" stroke="rgb(31,119,180)" cx="560.6961640134041" cy="597.9943000982026" r="4.5"/>
      </a>
      <a xlink:title="n300">
        <circle fill="rgb(255,255,255)" stroke="rgb(31,119,180)" cx="614.2615520178721" cy="663.9924001309369" r="4.5"/>
      </a>
      <a xlink:title="n112">
        <circle fill="rgb(255,255,255)" stroke="rgb(31,119,180)" cx="412.90177838356027" cy="484.0151421741432" r="4.5"/>
      </a>
      <a xlink:title="n287">
        <circle fill="rgb(255,255,255)" stroke="rgb(31,119,180)" cx="425.80355676712054" cy="568.0302843482864" r="4.5"/>
      </a>
    </g>
  </g>
</svg>]

puts str

doc = REXML::Document.new(str)
puts doc
ids = []
dots = []
doc.elements.each('svg/g/g/a') do |ele|
		ids << ele.attribute("xlink:title")
end
doc.elements.each('svg/g/g/a/circle') do |ele|
		x = (ele.attribute("cx").to_s).to_f
		y = (ele.attribute("cx").to_s).to_f
   	dots << {:x => x, :y => y}
end

# print all events
ids.each_with_index do |id, i|
   puts "#{id} => #{dots[i][:x]} #{dots[i][:y]}"
end
