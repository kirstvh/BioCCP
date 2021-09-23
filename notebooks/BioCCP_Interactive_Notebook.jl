### A Pluto.jl notebook ###
# v0.16.0

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : missing
        el
    end
end

# ╔═╡ bccc6db2-132b-4300-bf9f-f60260b7cff5
import Pkg; Pkg.add(url="https://github.com/kirstvh/BioCCP.jl")

# ╔═╡ 2d3ad982-ef1f-45ae-b247-9679c0faa853
using Plots, PlutoUI, BioCCP

# ╔═╡ 38b4c196-4df3-4585-81f1-ea1156cd4777
md"                                                             $(@bind date DateField())"

# ╔═╡ 4d246460-af05-11eb-382b-590e60ba61f5
md"## Collecting Coupons in combinatorial biotechnology

This notebook provides functions and corresponding visualizations to determine expected minimum sample sizes for combinatorial biotechnology experiments, based on the mathematical framework of the Coupon Collector Problem (references see [^1], [^2]).

"

# ╔═╡ a2fd6000-1450-4dfe-9426-5303ae64bfb3
md"""Please install the packages `BioCCP`, `Plots` and `PlutoUI` in the Julia Package Manager for this notebook to work."""

# ╔═╡ 9e6f350b-5eb0-4582-9ae3-2f28f8f5aa99
begin
	function tocsv(raw)
	t = string(raw)
	t = split(t, "[")[2]
	t = split(t, "]")[1]
	return t
	end
	md""
end

# ╔═╡ a8c81622-194a-443a-891b-bfbabffccff1
begin
	
md""" 
 
👇 **COMPLETE THE FIELDS BELOW** 👇\
	*First, fill in the input parameters of your problem setting. Then, click outside the text field to update the report.*"""
end

# ╔═╡ a8dfb204-5c9c-4f37-aba9-0c5ac8410550
Show(MIME"image/png"(), read("BioCCP_scheme.png"))

# ╔═╡ dcb66a31-d7ad-4179-ac37-dc8c9a043c92


# ╔═╡ 9595d38f-de74-4e61-9460-4b15393fb514
begin
	vec_n = [];
	md"""🔹 **№ modules in design space** (`n`):                       $(@bind n_string TextField(default = "100")) $(@bind help_n Button("❓"))"""
end

# ╔═╡ 5e932740-18cb-4427-b5f1-97b070d645db
begin
	help_n
	switch_n = rem(length(vec_n), 2)
	push!(vec_n, 1)
	if switch_n == 1
		md"""
	                                                       =   *How many different modules or building                                                    blocks are available to construct designs?*"""
	end
end

# ╔═╡ 2c86cbeb-8313-495a-8de1-43dd11d86258
begin
	vec_r = []
md""" 	
🔹 **Expected № modules per design** (`r`):                      $(@bind r NumberField(1:20)) $(@bind help_r Button("❓")) """
	
end

# ╔═╡ 7394f732-a5e4-4d3b-bdc8-618a63c4ab47
begin
	help_r
	switch_r = rem(length(vec_r), 2)
	push!(vec_r, 1)
	if switch_r == 1
		md"""
	
                                                 =    *How many modules are combined in                                                   a single design, on average?*"""
	end
end

# ╔═╡ ff2de850-c03b-4866-85cc-07405013dea1
begin
	vec_m = []
md""" 
**🔹 № times you want to observe each module** (`m`):              $(@bind m NumberField(1:20)) $(@bind help_m Button("❓")) """
	
end

# ╔═╡ 3139240c-2c45-47b0-b0d3-83f23f328a1a
begin
	help_m
	switch_m = rem(length(vec_m), 2)
	push!(vec_m, 1)
	if switch_m == 1
		md"""
	                                                    = 	   *How many times do you want to                                                     observe each of the available modules in                                                               the total set of designs?*"""
	end
end

# ╔═╡ 8b684e79-15a8-494c-a58a-811e5d91280a
begin
	vec_p = []
md"""🔹 **Abundances of modules during library generation** (`p`):     $(@bind ps Select(["Equal", "Unequal"], default = "Equal"))  $(@bind help_p Button("❓"))"""                    
	
end

# ╔═╡ 252fa1bd-fbdf-454a-8f0a-2dd835a94650
begin
	help_p
	switch_p = rem(length(vec_p), 2)
	push!(vec_p, 1)
	if switch_p == 1
		md"""                           
                
			      =    *How are the abundances of the                                                                 modules distributed during combinatorial                                                              generation of designs?
	Is each module                                                                    equally likely to be included in a design?*"""
	end
end

# ╔═╡ 45507d48-d75d-41c9-a018-299e209f900e
begin
	vec_p_unequal = []
	n = parse(Int64, n_string);
	if ps == "Equal"
		distribution = "Equal"
	end
		if ps == "Unequal"	
	md""" ↳     **Specify distribution**:                                                                           
	      $(@bind distribution Select(["Bell curve", "Zipf's law", "Custom vector"], default = " "))"""
		end	
end

# ╔═╡ 9248311f-2888-49ca-b30c-b3be77b491f6
if ps == "Unequal"

md"""
    *If the exact module probabilities are known, choose "Custom vector".* 
 *Otherwise, select:*
  - *"Zipf's law" (when you expect a small number of modules to occur quite often, and a very large number of modules to occur at the statistical equivalent of zero, but, they do occur.)* 
  - *"Bell curve" (when you expect a large number of modules to occur at an average probability and a smaller number of modules to occur with a small or large probability)* """
end

# ╔═╡ e3b4c2d8-b78c-467e-a863-5eecb8ec58dc
begin
	if distribution == "Zipf's law" || distribution == "Bell curve"	
		md"""                          ↳     **Specify pₘₐₓ/pₘᵢₙ**:         $(@bind pmaxpmin_string TextField(default = "4"))                                                 =    *The ratio of the largest and smallest                                                   module probability*"""
			end

end

# ╔═╡ 2639e3fb-ccbb-44de-bd15-1c5dbf6c1539
begin
	if distribution == "Custom vector"
				md"""        **↳  Enter/load your custom abundances by changing the cell below 👇**"""			
		end
end

# ╔═╡ 44d4dfee-3073-49aa-867c-3abea10e6e37
if distribution == "Custom vector"
	
	md"""                                            $(@bind abundances_str TextField((30, 10), 	default=join(string.(rand(200:1:400, n)), "\n")))
	                                           *Make sure the number of abundances is equal to n!*"""
end


# ╔═╡ 46c4de2b-99d7-462c-83a8-7d61de9a70a5
begin
	function tonumbers(text) 
		text = split(text, "\n")
		text = rstrip.(text)
		text = text[text .!= ""]
		text = parse.(Float64,text)
		return text
	end
	
	if distribution == "Custom vector"
		abundances = (tonumbers(abundances_str))
	end
	
	md""
end

# ╔═╡ f6ebf9fb-0a29-4cb4-a544-6c6e32bedcc4
md"""	
 
🎯 **REPORT**  🎯

**💻 Module probabilities**                                                                                                                       $(@bind show_modprobs Select(["🔻 SHOW ", "🔺 HIDE "], default="🔺 HIDE ") )  \
*How the abundances of the modules are distributed during combinatorial library generation.*
"""

# ╔═╡ d4a9da7a-f455-426b-aecd-227c25e1d4e8
begin
	
function p_power(n, k)
    p = (1:n) .^ -k
    return p ./ sum(p)
end
	if ps == "Equal"
	 	
		p = ones(n)./sum(ones(n));
		
	elseif ps == "Unequal"
		if distribution == "Bell curve"
			ratio = parse(Float64, pmaxpmin_string)
			ab1 = 1
			ab2 = ratio*ab1
			μ = (ab1+ab2)/2
			σ = (ab2-ab1)/6
			
			#create fixed distribution of abundances according to percentiles of bell curve
			n_perc_1 = Int(floor(n*0.34)); 
			n_perc_2 = Int(floor(n*0.135));
			n_perc_3 = Int(floor(n*0.0215));
			#n_perc_4 = Int(floor(n*0.0013));
			n_perc_rest = n - 2*n_perc_1 - 2*n_perc_2 - 2*n_perc_3 ;
			p_unnorm = vcat(fill(μ,2*n_perc_1+n_perc_rest), fill(μ+1.5*σ, n_perc_2), fill(μ-1.5*σ, n_perc_2), fill(μ+3*σ, n_perc_3), fill(μ-3*σ, n_perc_3) )
		
			# normalize sum to 1
			p = sort(p_unnorm ./ sum(p_unnorm))
		end
		
		if distribution == "Custom vector"
			p_unnorm = abundances
			p = abundances ./ sum(abundances)
		end
		
		if distribution == "Zipf's law"
			ratio = parse(Float64, pmaxpmin_string)
			p = p_power(n, log(ratio)/log(n))
			p = p ./ sum(p)
		end
	end
	
	if show_modprobs == "🔻 SHOW "   
	
	scatter(p, title = "Probability mass function", ylabel = "module probability pⱼ", xlabel = "module j", label="", size = (700, 400))
	ylims!((0, 1.1*(maximum(p) + maximum(p)-minimum(p))), titlefont=font(10), xguidefont=font(9), yguidefont=font(9))

	end	
end

# ╔═╡ 87c3f5cd-79bf-4ad8-b7f8-3e98ec548a9f
begin
	if show_modprobs == "🔻 SHOW "  && distribution == "Bell curve"
		histogram(p, normalize=:probability,  bar_edges=false,  size = (500, 250), orientation=:v, bins=[(μ -  3.2*σ)/sum(p_unnorm), (μ - 2*σ)/sum(p_unnorm), (μ-σ)/sum(p_unnorm), (μ + σ)/sum(p_unnorm), (μ + 2*σ)/sum(p_unnorm), (μ +  3.2*σ)/sum(p_unnorm)], titlefont=font(10), xguidefont=font(9), yguidefont=font(9), label="")
		# if distribution == "Normally distributed"
		# 	plot!(x->pdf(Normal(μ, σ), x), xlim=xlims())
		# 	xlabel!("Abundance"); ylabel!("probability"); title!("Distribution of module abundances")
		# end
		xlabel!("Probability"); ylabel!("Relative frequency"); title!("Distribution of module probabilities")
	end	
end

# ╔═╡ d877bd4c-497d-46d1-9c58-b6fe26933bfc
begin
	if show_modprobs == "🔻 SHOW "  && distribution == "Bell curve"
md"""For $n_string modules of which the probabilities form a bell curve with ratio pₘₐₓ/pₘᵢₙ = $pmaxpmin_string , we follow the percentiles of a normal distribution to generate the probability vector.

We consider μ to be the mean module probability and σ to be the standard deviation of the module probabilities.
		
According to the percentiles
- 68% of the module probabilities lies in the interval [μ - σ, μ + σ], 
- 95% of falls into the range [μ - 2σ, μ + 2σ] and 
- 99.7% lies in [μ - 3σ, μ +3σ]. 
		
We use the ratio pₘₐₓ/pₘᵢₙ to fix the width of the interval [μ - 3σ, μ +3σ]. (We assume that pₘₐₓ = μ +3σ and pₘᵢₙ = μ - 3σ and calculate μ and σ from this assumption). In addition, we make sure the sum of the probability vector sums up to 1.
		
As a result, we get:
-  $(n_perc_1+n_perc_rest) modules with a probability of $(µ/sum(p_unnorm))
-  $(n_perc_2)  modules with a probability of $((μ+1.5*σ)/sum(p_unnorm))
-  $(n_perc_2)  modules with a probability of $((μ-1.5*σ)/sum(p_unnorm))
-  $(n_perc_3)  modules with a probability of $((μ+2.5*σ)/sum(p_unnorm))
-  $(n_perc_3)  modules with a probability of $((μ-2.5*σ)/sum(p_unnorm))"""
	end	
end

# ╔═╡ f098570d-799b-47e2-b692-476a4d95825b
if show_modprobs == "🔻 SHOW " 
md"Each biological design in the design space is built by choosing $r module(s) (with replacement) out of a set of $n_string modules according to the module probabilities visualized above."
end

# ╔═╡ 2926cbcc-23ff-49cd-a952-b6e188d1d838


# ╔═╡ caf67b2f-cc2f-4d0d-b619-6e1969fabc1a
md""" **💻 Expected minimum sample size**                                                                                                             $(@bind show_E Select(["🔻 SHOW ", "🔺 HIDE "], default="🔺 SHOW ")) 
\
*The expected minimum number of designs to observe each module at least $m time(s) in the sampled set of designs.* """  

# ╔═╡ 6f14a72c-51d3-4759-bb8b-10db1dc260f0
begin
	if show_E == "🔻 SHOW "   
		E = Int(ceil(expectation_minsamplesize(n; p = p, m=m, r = r)))
		sd = Int(ceil(std_minsamplesize(n; p = p, m=m, r = r)))
		
			md""" 
     `Expected minimum sample size`     = **$E designs**\
		
     `Standard deviation             `                           = **$sd designs**  	"""
	end
end

# ╔═╡ 3c07dd11-5be7-4ec7-992e-38dd07260d71


# ╔═╡ 22fe8006-0e81-4e0a-a460-28610a55cd97
md""" **💻 Success probability**                                                                                                                  $(@bind show_success Select(["🔻 SHOW ", "🔺 HIDE "], default="🔺 HIDE ") )\

*The probability that the minimum number of designs T is smaller than or equal to a given sample size t.* """

# ╔═╡ db4371e4-7f86-4db3-b076-12f6cd220b89
begin
	if show_success == "🔻 SHOW " 
		sample_size_95 = Int(1)
		while (0.95 - success_probability(n, Int(ceil((sample_size_95))); 
					p = p, r = r, m = m)) > 0.00005
		global sample_size_95 += Int(ceil(n/10))
	end
		md"""    👉 Enter your sample size of interest: $(@bind sample_size_1_string TextField(default=string(sample_size_95)))""" 
		
	end
end

# ╔═╡ 317995ed-bdf4-4f78-bd66-a39ffd1dc452
begin
	
	if show_success == "🔻 SHOW " 
	sample_size_1 = parse(Int64, sample_size_1_string);	
	p_success = success_probability(n, Int(ceil.(sample_size_1)); p = p, m = m, r = r)
	
	md""" 
              ↳ `Success probability F(t)`  = **$p_success**\
	"""
	end
end

# ╔═╡ 5b559573-9e55-4618-9b9d-f6d4f5aeb5a5


# ╔═╡ ca5a4cef-df67-4a5e-8a86-75a9fe8c6f37
if show_success == "🔻 SHOW " 
	md"*A curve describing the success probability in function of sample size.*"
end

# ╔═╡ 24f7aae7-d37a-4db5-ace0-c910b178da88
begin
if show_success == "🔻 SHOW " 
	
	sample_size_initial = Int(5)
	while (1 - success_probability(n, Int(ceil((sample_size_initial))); 
					p = p, r = r, m = m)) > 0.0005
		global sample_size_initial += ceil(n/10)
	end
		
	sample_sizes = Int.(0: ceil(n/10) :sample_size_initial)
	successes = success_probability.(n, Int.(ceil.(sample_sizes)); 
			p = p, r = r, m = m)
	plot(sample_sizes, successes, 
			title = "Success probability in function of sample size", 
			xlabel = "sample size s", ylabel= "P(s ≤ Sₘᵢₙ)", label = "",
			legend=:bottomright, size=(600,400), seriestype=:scatter, 
			titlefont=font(10), xguidefont=font(9), yguidefont=font(9))
		end
	 
end

# ╔═╡ 6d9ecb9d-6656-4bb2-ae58-caddd173adbc
if show_success == "🔻 SHOW " 
	DownloadButton(string("sample_size,", tocsv(sample_sizes), "\n", "success_probability,", tocsv(successes)), "successprobability_$date.csv")
end

# ╔═╡ 37f951ee-885c-4bbe-a05f-7c5e48ff4b6b
begin
	#following one-sided version of Chebyshev's inequality.
	 
	function chebyshev_onesided_larger(X, μ, σ)
		X_μ = X - μ
		return σ^2 / (σ^2 + X_μ^2)
	end
	function chebyshev_onesided_smaller(X, μ, σ)
		X_μ = μ - X
		return σ^2 / (σ^2 + X_μ^2)
	end
if show_success == "🔻 SHOW "
if sample_size_1 < E
	compare = "smaller"
		if sample_size_1 <= n/r
			print_sentence = "P(minimum sample size ≤ $sample_size_1) = 0."        
		else
	prob_chebyshev = chebyshev_onesided_smaller(sample_size_1, E, sd)
	print_sentence = "P(minimum sample size ≤ $sample_size_1) ≤ $prob_chebyshev. "
		end
		
elseif sample_size_1 > E
	compare = "greater"
	prob_chebyshev = chebyshev_onesided_larger(sample_size_1, E, sd)
	print_sentence = "P(minimum sample size ≥ $sample_size_1) ≤ $prob_chebyshev. "	
		
	elseif sample_size_1==E
		print_sentence = "P(minimum sample size ≤ $sample_size_1 OR minimum sample size ≥ $sample_size_1) ≤ 1."
		
end

	md"""*Upper bound on probability that minimum sample size is smaller than given sample size t, according to Chebychev's inequality*:
	                                                                                                                                            
		$print_sentence"""
	end
end

# ╔═╡ ca33610c-1be9-4c01-b0b7-ce4b2f7896df


# ╔═╡ dc696281-7a5b-4568-a4c2-8dde90af43f0
md""" **💻 Expected observed fraction of the total number of modules**                $(@bind show_satur Select(["🔻 SHOW ", "🔺 HIDE "], default="🔺 HIDE "))\
*The fraction of the total number of available modules that is expected to be observed after collecting a given number of designs.*"""

# ╔═╡ eb92ff7c-0140-468c-8b32-f15d1cf15913
if show_satur == "🔻 SHOW " 
		md"""
   👉 Enter your sample size of interest: $(@bind sample_size_2_string TextField(default="50")) """ 
end

# ╔═╡ f0eaf96b-0bc0-4194-9a36-886cb1d66e00
begin
	if show_satur == "🔻 SHOW " 
	sample_size_2 = parse(Int64, sample_size_2_string)
	E_fraction = expectation_fraction_collected(n, Int(ceil(sample_size_2)); p = p, r = r)
	
	md""" 	            ↳ `Expected fraction observed`	= **$E_fraction**
	"""	
	end
end

# ╔═╡ db06b1d2-19f1-450f-9b31-975a432d3b9f


# ╔═╡ 0099145a-5460-4549-9513-054bc1b04eea
if  show_satur == "🔻 SHOW " 
md""" *A curve describing the expected fraction of modules observed in function of sample size.* """
	end

# ╔═╡ 7968de5e-5ae8-4ab4-b089-c3d33475af2f
begin
	if show_satur == "🔻 SHOW " 
		global sample_size_initial_frac = Int(5)
		while (1 - expectation_fraction_collected(n, 
					Int(ceil(sample_size_initial_frac)); p = p, r = r)) > 0.0005
			global	 sample_size_initial_frac += Int(ceil(n/10))
		end
	
	sample_sizes_frac = Int.(0: n/10 : sample_size_initial_frac)	
	fracs = expectation_fraction_collected.(n, Int.(ceil.(sample_sizes_frac)); 
			p = p, r = r)
	
	plot(sample_sizes_frac, fracs, 
			title = "Expected observed fraction of the total number of modules",
			xlabel = "sample size", seriestype=:scatter, 
			ylabel= "E[fraction observed]", 
			label = "", size=(700,400), 
			titlefont=font(10), xguidefont=font(9), yguidefont=font(9))
end
end

# ╔═╡ 84a2a4de-0667-4120-919a-06e2119112c0
if show_satur == "🔻 SHOW " 
	DownloadButton(string("sample_size,", tocsv(sample_sizes_frac), "\n", "expected_observed_fraction,", tocsv(fracs)), "expectedobservedfraction_$date.csv")
end

# ╔═╡ f92a6b6e-a556-45cb-a1ae-9f5fe791ffd2
md""" **💻 Occurrence of a specific module**                                                                                                       $(@bind show_occ Select(["🔻 SHOW ", "🔺 HIDE "], default="🔺 HIDE "))\
*How many times one can expect to have collected a specific module in a sample of a given size.*"""

# ╔═╡ ec2a065f-0dc7-44d4-a18b-6c6a228b3ffc
if show_occ == "🔻 SHOW " && distribution != "Zipf's law"
	md"""    👉 Enter the probability of the module of interest: $(@bind p_string TextField(default="0.005"))\
	""" 	
	
end

# ╔═╡ d8f1d60b-51ce-4f6e-a944-b2e02c8e9455
if show_occ == "🔻 SHOW " && distribution == "Zipf's law"
	md"""    👉 Enter the rank of the module of interest:        $(@bind rank_string TextField(default="5"))\
	""" 		
end

# ╔═╡ 0e39a993-bb2f-4897-bfe2-5128ec62bef9
if show_occ == "🔻 SHOW "
	 md"""    👉 Enter the sample size of interest:                $(@bind sample_size_3_string TextField(default="500"))"""
end

# ╔═╡ a6d6a782-d800-4c06-a0ec-2fd36df01075


# ╔═╡ 6acb0a97-6469-499f-a5cf-6335d6aa909a
begin	
if show_occ == "🔻 SHOW " 
	sample_size_3 = parse(Int64, sample_size_3_string)
	if distribution != "Zipf's law"
		pᵢ = parse(Float64, p_string)
		
		ed = Int(floor(sample_size_3*pᵢ))
		j = collect(0:1:minimum([20, 5*ed]))
		x  = prob_occurrence_module.(pᵢ, Int(ceil(sample_size_3)), j)
		plot(j,x, seriestype=[:line, :scatter], xlabel="№ occurrences in sample", ylabel="probability", title="Probability on № of occurrences for specific module", label="", size=((600,300)), titlefont=font(10),xguidefont=font(9), yguidefont=font(9))
	
	else
		rank = parse(Int64, rank_string)
		pᵢ = p[rank]
		ed = Int(floor(sample_size_3*pᵢ))
		j = collect(0:1:minimum([20, 5*ed]))
		x  = prob_occurrence_module.(pᵢ, Int(ceil(sample_size_3)), j)
	 	plot(j,x, seriestype=[:line, :scatter], xlabel="№ occurrences in sample", ylabel="probability", title="Probability on № of occurrences for specific module", size=((600,300)), label="", titlefont=font(10), xguidefont=font(9), yguidefont=font(9))			
	end
	end
end

# ╔═╡ 595423df-728b-43b1-ade4-176785c54be3
begin
	if show_occ == "🔻 SHOW " 
		
	md""" 	            ↳ `Expected number of times observed `	≈ **$ed**
		"""
	end
end

# ╔═╡ 1d17eed5-ed16-4e8a-8a81-6405ec89e739
if show_occ == "🔻 SHOW " 
	DownloadButton(string("number_of_occurence,", tocsv(j), "\n", "probability,", tocsv(x)), "occurrencemodule_$date.csv")
end

# ╔═╡ fbffaab6-3154-49df-a226-d5810d0b7c38
md"""## References"""

# ╔═╡ 1f48143a-2152-4bb9-a765-a25e70c281a3
md"""[^1]:  Doumas, A. V., & Papanicolaou, V. G. (2016). *The coupon collector’s problem revisited: generalizing the double Dixie cup problem of Newman and Shepp.* ESAIM: Probability and Statistics, 20, 367-399.

[^2]: Boneh, A., & Hofri, M. (1997). *The coupon-collector problem revisited—a survey of engineering problems and computational methods.* Stochastic Models, 13(1), 39-66.



"""


# ╔═╡ Cell order:
# ╟─38b4c196-4df3-4585-81f1-ea1156cd4777
# ╟─4d246460-af05-11eb-382b-590e60ba61f5
# ╟─a2fd6000-1450-4dfe-9426-5303ae64bfb3
# ╠═bccc6db2-132b-4300-bf9f-f60260b7cff5
# ╠═2d3ad982-ef1f-45ae-b247-9679c0faa853
# ╟─9e6f350b-5eb0-4582-9ae3-2f28f8f5aa99
# ╟─a8c81622-194a-443a-891b-bfbabffccff1
# ╟─a8dfb204-5c9c-4f37-aba9-0c5ac8410550
# ╟─dcb66a31-d7ad-4179-ac37-dc8c9a043c92
# ╟─9595d38f-de74-4e61-9460-4b15393fb514
# ╟─5e932740-18cb-4427-b5f1-97b070d645db
# ╟─2c86cbeb-8313-495a-8de1-43dd11d86258
# ╟─7394f732-a5e4-4d3b-bdc8-618a63c4ab47
# ╟─ff2de850-c03b-4866-85cc-07405013dea1
# ╟─3139240c-2c45-47b0-b0d3-83f23f328a1a
# ╟─8b684e79-15a8-494c-a58a-811e5d91280a
# ╟─252fa1bd-fbdf-454a-8f0a-2dd835a94650
# ╟─45507d48-d75d-41c9-a018-299e209f900e
# ╟─9248311f-2888-49ca-b30c-b3be77b491f6
# ╟─e3b4c2d8-b78c-467e-a863-5eecb8ec58dc
# ╟─2639e3fb-ccbb-44de-bd15-1c5dbf6c1539
# ╟─44d4dfee-3073-49aa-867c-3abea10e6e37
# ╟─46c4de2b-99d7-462c-83a8-7d61de9a70a5
# ╟─f6ebf9fb-0a29-4cb4-a544-6c6e32bedcc4
# ╟─87c3f5cd-79bf-4ad8-b7f8-3e98ec548a9f
# ╟─d877bd4c-497d-46d1-9c58-b6fe26933bfc
# ╟─d4a9da7a-f455-426b-aecd-227c25e1d4e8
# ╟─f098570d-799b-47e2-b692-476a4d95825b
# ╟─2926cbcc-23ff-49cd-a952-b6e188d1d838
# ╟─caf67b2f-cc2f-4d0d-b619-6e1969fabc1a
# ╟─6f14a72c-51d3-4759-bb8b-10db1dc260f0
# ╟─3c07dd11-5be7-4ec7-992e-38dd07260d71
# ╟─22fe8006-0e81-4e0a-a460-28610a55cd97
# ╟─db4371e4-7f86-4db3-b076-12f6cd220b89
# ╟─317995ed-bdf4-4f78-bd66-a39ffd1dc452
# ╟─5b559573-9e55-4618-9b9d-f6d4f5aeb5a5
# ╟─ca5a4cef-df67-4a5e-8a86-75a9fe8c6f37
# ╟─24f7aae7-d37a-4db5-ace0-c910b178da88
# ╟─6d9ecb9d-6656-4bb2-ae58-caddd173adbc
# ╟─37f951ee-885c-4bbe-a05f-7c5e48ff4b6b
# ╟─ca33610c-1be9-4c01-b0b7-ce4b2f7896df
# ╟─dc696281-7a5b-4568-a4c2-8dde90af43f0
# ╟─eb92ff7c-0140-468c-8b32-f15d1cf15913
# ╟─f0eaf96b-0bc0-4194-9a36-886cb1d66e00
# ╟─db06b1d2-19f1-450f-9b31-975a432d3b9f
# ╟─0099145a-5460-4549-9513-054bc1b04eea
# ╟─7968de5e-5ae8-4ab4-b089-c3d33475af2f
# ╟─84a2a4de-0667-4120-919a-06e2119112c0
# ╟─f92a6b6e-a556-45cb-a1ae-9f5fe791ffd2
# ╟─ec2a065f-0dc7-44d4-a18b-6c6a228b3ffc
# ╟─d8f1d60b-51ce-4f6e-a944-b2e02c8e9455
# ╟─0e39a993-bb2f-4897-bfe2-5128ec62bef9
# ╟─a6d6a782-d800-4c06-a0ec-2fd36df01075
# ╟─6acb0a97-6469-499f-a5cf-6335d6aa909a
# ╟─595423df-728b-43b1-ade4-176785c54be3
# ╟─1d17eed5-ed16-4e8a-8a81-6405ec89e739
# ╟─fbffaab6-3154-49df-a226-d5810d0b7c38
# ╟─1f48143a-2152-4bb9-a765-a25e70c281a3
