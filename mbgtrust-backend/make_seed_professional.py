import re

path = 'prisma/seed.js'
with open(path, 'r', encoding='utf-8') as f:
    content = f.read()

# 1. Change password
content = content.replace("'password123'", "'MbgTrust@2026!'")

# 2. Change admin emails
content = content.replace("email: dmin.sekolah@sppg.id", "email: dmin.sppg@mbgtrust.go.id")

# 3. Change student names
old_names = """  const namaSiswa = [
    'Ahmad Fauzi', 'Budi Santoso', 'Citra Dewi', 'Dani Pratama', 'Eka Putri',
    'Fajar Ramadan', 'Gina Lestari', 'Hendra Wijaya', 'Indah Sari', 'Joko Purnomo'
  ];"""
new_names = """  const namaSiswa = [
    'Aditya Pratama Putra', 'Bunga Citra Maharani', 'Clarissa Devira', 'Danishwara Al-Fatih', 'Erlangga Kusuma',
    'Fathir Muhammad', 'Giselle Anatasya', 'Hafizh Syahputra', 'Intan Permata Sari', 'Jovanka Aurelia'
  ];"""
content = content.replace(old_names, new_names)

# 4. Change reviews
old_reviews = """  const contohUlasan = [
    'Ayamnya sangat gurih dan renyah, porsinya pas bikin kenyang!',
    'Sayurnya segar dan bersih, enak banget dimakan hangat-hangat.',
    'Rasanya lezat dan mantap, tapi nasinya agak sedikit dingin.',
    'Ikan bakarnya agak asin dan sedikit berminyak, tapi ikannya empuk.',
    'Porsinya kurang banyak untuk saya, tapi rasanya lumayan enak.',
    'Kurang suka karena agak hambar dan sayurnya sedikit alot.',
    'Menu favorit saya! Bumbunya meresap dan sangat nikmat juara.',
    'Dagingnya empuk banget dan kuahnya gurih sedap.',
  ];"""
new_reviews = """  const contohUlasan = [
    'Tekstur daging sangat empuk dan bumbunya meresap dengan baik. Porsi karbohidrat dan protein sangat seimbang.',
    'Sayuran dimasak dengan tingkat kematangan yang pas, menjaga kesegaran dan warna alaminya. Sangat memuaskan.',
    'Rasa secara keseluruhan sangat lezat, namun suhu nasi saat disajikan sudah agak menurun.',
    'Kualitas ikan segar dan tidak amis, meskipun sedikit terlalu berminyak di bagian kulitnya.',
    'Distribusi porsi sayur dan lauk pauk sangat proporsional. Sangat mendukung pemenuhan gizi seimbang harian.',
    'Bumbu sayur terasa sedikit kurang kuat (hambar) dan teksturnya sedikit keras saat dikunyah.',
    'Kombinasi menu hari ini sangat luar biasa. Cita rasa Nusantara terasa sangat otentik dan menggugah selera.',
    'Kualitas potongan daging sangat premium, kuah kaldu kaya akan rempah dan disajikan dalam keadaan hangat.',
  ];"""
content = content.replace(old_reviews, new_reviews)

# 5. Change print logs
content = content.replace("sandi: password123", "sandi: MbgTrust@2026!")
content = content.replace("email: admin.sekolah1@sppg.id", "email: admin.sppg1@mbgtrust.go.id")

with open(path, 'w', encoding='utf-8') as f:
    f.write(content)

print('seed.js made professional')
