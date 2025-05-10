# Garanti Teknoloji iOS Case Study

## İçindekiler
- [Genel Bakış](#genel-bakış)
- [Mimari ve Tasarım Kararları](#mimari-ve-tasarım-kararları)
- [Klasör Yapısı](#klasör-yapısı)
- [Kullanılan Teknolojiler ve Bağımlılıklar](#kullanılan-teknolojiler-ve-bağımlılıklar)
- [Kurulum ve Çalıştırma](#kurulum-ve-çalıştırma)
- [Özellikler](#özellikler)
- [Testler](#testler)
- [Geliştirme ve İyileştirme Alanları](#geliştirme-ve-iyileştirme-alanları)
- [Ekran Görüntüleri](#ekran-görüntüleri)
- [Katkıda Bulunanlar](#katkıda-bulunanlar)

---

## Genel Bakış

Bu proje, Garanti Teknoloji iOS Case Study gereksinimlerine uygun olarak, modern ve sürdürülebilir bir mobil mimariyle geliştirilmiştir.  
Tüm ekranlar programatik olarak UIKit ile yazılmış, MVVM, SOLID ve OOP prensiplerine uygun olarak yapılandırılmıştır.

---

## Mimari ve Tasarım Kararları

- **MVVM Pattern:** View, ViewModel ve Model katmanları net şekilde ayrılmıştır.
- **SOLID Prensipleri:** Tüm servisler protokol tabanlı, bağımlılıklar injection ile yönetilir.
- **Network Katmanı:** Protokol bazlı, generic ve test edilebilir NetworkManager.
- **Cache Katmanı:** Session bazlı, RAM ve UserDefaults destekli cache.
- **Localization:** Türkçe ve İngilizce desteği, dinamik dil değişimi.
- **Firebase:** Analytics, Crashlytics, Remote Config, Messaging modülleri entegre.
- **Test Edilebilirlik:** Tüm ViewModel'ler ve cache katmanı için mock ile unit testler.
- **UI Standartları:** Figma'ya uygun spacing, font, grid, extension'lar.

---

## Klasör Yapısı

```
GTCaseStudy/
  Network/
  Cache/
  Model/
  ViewModel/
  View/
  Coordinator/
  Extensions/
  Localization/
  Resources/
  GTCaseStudyTests/
```

---

## Kullanılan Teknolojiler ve Bağımlılıklar

- Swift, UIKit
- Firebase (Analytics, Crashlytics, Remote Config, Messaging)
- UserDefaults, URLSession
- XCTest (Unit Test)
- Figma (UI Tasarım)

---

## Kurulum ve Çalıştırma

1. Projeyi klonlayın.
2. `pod install` veya Swift Package Manager ile bağımlılıkları yükleyin.
3. `GoogleService-Info.plist` dosyasını ekleyin.
4. Xcode ile açıp çalıştırın.

---

## Özellikler

- Login ve Discover ekranları (Figma'ya uygun)
- 5'li TabBar, sadece Discover dolu, diğerleri "Coming Soon"
- Discover ekranında 3 farklı endpoint'ten veri çekme ve cache'leme
- Pull to Refresh desteği
- Türkçe/İngilizce localization
- Firebase event/crash/remote config örnekleri
- Kod tekrarını azaltan extension'lar
- Test edilebilir, sürdürülebilir mimari

---

## Testler

- Tüm ViewModel'ler için mock network ve cache ile unit testler
- Edge-case ve hata senaryoları test kapsamına dahil
- Testler hızlı, izole ve sürdürülebilir şekilde yazıldı

---

## Geliştirme ve İyileştirme Alanları

- UI testleri eklenebilir
- Daha gelişmiş dependency injection (Swinject vb.)
- Dark mode ve accessibility desteği
- Ekstra dokümantasyon ve mimari diyagramlar
- Remote config ve push notification örnekleri artırılabilir

---

## Katkıda Bulunanlar

- Samet Yatmaz

---

### Notlar

- Proje, mimari temizlik, test edilebilirlik ve sürdürülebilirlik açısından öne çıkacak şekilde hazırlanmıştır.
- Tüm önemli katmanlar için protokol bazlı, mock ile test edilebilir yapıdadır.
- Kodun okunabilirliği, tekrar kullanılabilirliği ve bakımı ön planda tutulmuştur. 