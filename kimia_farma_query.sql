CREATE TABLE `rakamin-kf-analytics-4867.kimia_farma.kimia_farma_analytic_table` AS
SELECT
  -- Memilih kolom dari tabel kf_final_transaction (diberi alias 't')
  t.transaction_id,
  t.date,
  t.customer_name,
  t.price AS actual_price, -- mengubah nama kolom 'price' menjadi 'actual_price'
  t.discount_percentage,
  t.rating AS rating_transaksi, -- mengubah nama kolom 'rating' menjjadi 'rating_transaksi'


  -- Memilih kolom dari tabel kf_kantor_cabang (diberi alias 'kc')
  kc.branch_id,
  kc.branch_name,
  kc.kota,
  kc.provinsi,
  kc.rating AS rating_cabang, -- mengubah nama kolom 'rating' menjadi 'rating_cabang'


  -- Memilih kolom dari tabel kf_product (diberi alias 'p')
  p.product_id,
  p.product_name,
 
  -- kolom turunan: persentase_gross_laba
  -- Menggunakan eksprese CASE WHEN untuk menentukan persentase laba berdasarkan 'actual_price' (harga).
  -- Konsep ini melibatkan kondisi dan logika.
  CASE
    WHEN t.price <= 50000 THEN 0.10 --laba 10%
    WHEN t.price > 50000 AND t.price <= 100000 THEN 0.15 -- laba 15%
    WHEN t.price > 100000 AND t.price <= 300000 THEN 0.20 -- laba 20%
    WHEN t.price > 300000 AND t.price <= 500000 THEN 0.25 -- Laba 25%
    WHEN t.price > 500000 THEN 0.30 -- Laba 30%
    ELSE 0 -- Default jika tidak ada yang cocok
  END AS persentase_gross_laba,


  -- kolom turunan: nett_sales (harga setelah diskon)
  -- melakukan operasi aretmatika pada kolom 'price' dan 'discount_percentage'[cite: 582, 583, 649]
  t.price * (1 - t.discount_percentage) AS nett_sales,


  -- kolom turunan: nett_profit (keuntungan yang diperoleh Kimia Farma)
  -- Menghitung nett_profit berdasarkan 'nett_sales' dan 'persentase_gross_laba' yang dihitung di atas[cite: 582, 583, 649.
  (t.price * (1 - t.discount_percentage)) *
  (CASE
    WHEN t.price <= 50000 THEN 0.10
    WHEN t.price > 50000 AND t.price <= 100000 THEN 0.15
    WHEN t.price > 100000 AND t.price <= 300000 THEN 0.20
    WHEN t.price > 300000 AND t.price <= 500000 THEN 0.25
    WHEN t.price > 500000 THEN 0.30
    ELSE 0
  END) AS nett_profit
FROM
  -- Mengambil data dari tabel kf_final_transaction (tabel utama)
  `rakamin-kf-analytics-4867.kimia_farma.kf_final_transaction` AS t
LEFT JOIN
  -- Menggabungkan dengan tabel kf_kantor_cabang menggunakan LEFT JOIN berdasarkan 'branch_id'[cite: 291, 696]
  `rakamin-kf-analytics-4867.kimia_farma.kf_kantor_cabang` AS kc
  ON t.branch_id = kc.branch_id
LEFT JOIN
  -- Menggabungkan dengan tabel kf_product menggunakan LEFT JOIN berdasarkan 'product_id' [cite: 291, 696]
  `rakamin-kf-analytics-4867.kimia_farma.kf_product` AS p
  ON t.product_id = p.product_id
-- Catatan: Tabel kf_inventory tidak secara langsung digunakan dalam perhitungan kolom yang diminta
-- dalam tabel analisis ini, sehingga tidak perlu di-JOIN untuk query ini




