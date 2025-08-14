--ex Para cada cliente, retorne a data da última visita que ele fez antes de adicionar 
--algo no carrinho pela primeira vez.

--quando adicionou algo pela primeira vez
with primeira_adicao_carrinho as(
		select customer_id,
		min(add_to_cart_date) as data_primeiro_carrinho
	from sales.funnel
	where add_to_cart_date is not null
	group by customer_id -- agrupando por cliente
)

select fun.customer_id,
		max(fun.visit_page_date) as ultima_visita_antes_carrinho

from sales.funnel as fun
left join primeira_adicao_carrinho as pc
	on fun.customer_id = pc.customer_id
where visit_page_date < data_primeiro_carrinho
group by fun.customer_id


-- ex Liste os clientes que fizeram pelo menos uma nova
-- visita ao site depois da primeira vez que adicionaram algo ao carrinho.

--primeira vez que adicionaram algo
with primeira_adicao_carrinho as (
		select customer_id,
		min(add_to_cart_date) as data_primeiro_carrinho
	from sales.funnel
	where add_to_cart_date is not null
	group by customer_id
)


select distinct fun.customer_id as clientes_visitadores_apos_carrinho
	
from sales.funnel as fun
join primeira_adicao_carrinho as pv -- left deixaria entrar clientes que nem tem carrinho
	on fun.customer_id = pv.customer_id
where visit_page_date > data_primeiro_carrinho



--ex3 Para cada usuário, descubra quantas vezes ele visitou o site antes da sua primeira compra.

-- encontrar a data do primeiro add_to_cart por usuario
with primeira_adicao_carrinho as (
	select
		customer_id,
		min(add_to_cart_date) as data_primeiro_carrinho
	from sales.funnel
	where add_to_cart_date is not null
	group by customer_id -- agrupando por usuario    
)

--contar visitas anteriores a essa data

select 
	fun.customer_id,
	count(*) as visitas_antes_carrinho

from sales.funnel as fun
left join primeira_adicao_carrinho as pc
	on fun.customer_id = pc.customer_id
where fun.visit_page_date < pc.data_primeiro_carrinho
group by fun.customer_id --agrupando por usuario






