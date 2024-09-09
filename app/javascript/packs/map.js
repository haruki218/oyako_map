let map;
let currentMarker = null; // 現在のマーカー
let markers = []; // 複数マーカーの管理

async function initMap() {
    console.log("Initializing map...");
  const { Map } = await google.maps.importLibrary("maps");
  const { Marker } = await google.maps.importLibrary("marker");

  const prefectureCenters = {
    '北海道': { lat: 43.0687, lng: 141.3508 },
    '青森県': { lat: 40.8245, lng: 140.7405 },
    '岩手県': { lat: 39.7035, lng: 141.1526 },
    '宮城県': { lat: 38.2685, lng: 140.8720 },
    '秋田県': { lat: 39.7186, lng: 140.1023 },
    '山形県': { lat: 38.2404, lng: 140.3636 },
    '福島県': { lat: 37.7500, lng: 140.4677 },
    '茨城県': { lat: 36.3417, lng: 140.4468 },
    '栃木県': { lat: 36.5659, lng: 139.8835 },
    '群馬県': { lat: 36.3906, lng: 139.0604 },
    '埼玉県': { lat: 35.8570, lng: 139.6490 },
    '千葉県': { lat: 35.6045, lng: 140.1231 },
    '東京都': { lat: 35.6895, lng: 139.6917 },
    '神奈川県': { lat: 35.4477, lng: 139.6425 },
    '新潟県': { lat: 37.9024, lng: 139.0236 },
    '富山県': { lat: 36.6952, lng: 137.2113 },
    '石川県': { lat: 36.5946, lng: 136.6256 },
    '福井県': { lat: 36.0652, lng: 136.2217 },
    '山梨県': { lat: 35.6641, lng: 138.5684 },
    '長野県': { lat: 36.6513, lng: 138.1809 },
    '岐阜県': { lat: 35.3911, lng: 136.7236 },
    '静岡県': { lat: 34.9769, lng: 138.3830 },
    '愛知県': { lat: 35.1802, lng: 136.9065 },
    '三重県': { lat: 34.7302, lng: 136.5086 },
    '滋賀県': { lat: 35.0045, lng: 135.8685 },
    '京都府': { lat: 35.0212, lng: 135.7556 },
    '大阪府': { lat: 34.6863, lng: 135.5200 },
    '兵庫県': { lat: 34.6912, lng: 135.1830 },
    '奈良県': { lat: 34.6851, lng: 135.8049 },
    '和歌山県': { lat: 34.2261, lng: 135.1675 },
    '鳥取県': { lat: 35.5036, lng: 134.2383 },
    '島根県': { lat: 35.4723, lng: 133.0505 },
    '岡山県': { lat: 34.6617, lng: 133.9349 },
    '広島県': { lat: 34.3966, lng: 132.4596 },
    '山口県': { lat: 34.1861, lng: 131.4705 },
    '徳島県': { lat: 34.0658, lng: 134.5593 },
    '香川県': { lat: 34.3401, lng: 134.0434 },
    '愛媛県': { lat: 33.8416, lng: 132.7656 },
    '高知県': { lat: 33.5595, lng: 133.5311 },
    '福岡県': { lat: 33.6064, lng: 130.4183 },
    '佐賀県': { lat: 33.2492, lng: 130.2988 },
    '長崎県': { lat: 32.7448, lng: 129.8737 },
    '熊本県': { lat: 32.7898, lng: 130.7417 },
    '大分県': { lat: 33.2382, lng: 131.6125 },
    '宮崎県': { lat: 31.9110, lng: 131.4239 },
    '鹿児島県': { lat: 31.5602, lng: 130.5581 },
    '沖縄県': { lat: 26.2124, lng: 127.6809 }
  };

  const prefectureElement = document.getElementById('prefecture-name');
  const prefecture = prefectureElement ? prefectureElement.textContent.trim() : null;
  const center = prefectureCenters[prefecture] || { lat: 35.6895, lng: 139.6917 }; // デフォルトは東京

  map = new Map(document.getElementById("map"), {
    center: center,
    zoom: 15,
    mapTypeControl: false
  });
    // 投稿データを取得してマーカーを追加する処理
    try {
        const response = await fetch(`/maps/${prefecture}.json`); // サーバーから投稿データを取得
        if (!response.ok) throw new Error('Network response was not ok');
        const posts = await response.json();
        addMarkersToMap(posts); // マーカーを地図上に追加
    } catch (error) {
        console.error('Error fetching or processing posts:', error);
    }

    // 地図クリック時の処理
    if (document.getElementById('latitude') && document.getElementById('longitude')) {
        map.addListener('click', async (event) => {
            const latitude = event.latLng.lat();
            const longitude = event.latLng.lng();

            // 既存のマーカーを削除
            if (currentMarker) {
                currentMarker.setMap(null);
            }

            // 新しいマーカーを追加
            currentMarker = new Marker({
                position: { lat: latitude, lng: longitude },
                map: map,
            });

            // 緯度・経度から住所と郵便番号を取得
            try {
                const { address, postalCode } = await geocodeLatLng({ lat: latitude, lng: longitude });
                
                // 住所と郵便番号、緯度・経度をフォームに反映
                document.getElementById('post_address').value = address;
                document.getElementById('postal_code').value = postalCode;
                document.getElementById('latitude').value = latitude;
                document.getElementById('longitude').value = longitude;
            } catch (error) {
                console.error('Geocoding failed:', error);
                alert('住所情報の取得に失敗しました。再度お試しください。');
            }
        });
    }
}

// 複数のマーカーを地図に追加
function addMarkersToMap(posts) {
    posts.forEach(post => {
        const { latitude, longitude, title, average_rating, tags, facility_type } = post;

        if (latitude && longitude) {
            // アイコンの選択
            let iconUrl;
            if (facility_type === 'nursing_room') {
                iconUrl = '/assets/nursing_room_icon.png'; // 授乳室用アイコン
            } else if (facility_type === 'diaper_changing_station') {
                iconUrl = '/assets/diaper_changing_icon.png'; // おむつ替え用アイコン
            } else {
                iconUrl = '/assets/play_icon.png';  // 遊び場用アイコン
            }

            const marker = new google.maps.Marker({
                position: { lat: parseFloat(latitude), lng: parseFloat(longitude) },
                map,
                title: title,
                icon: iconUrl, // アイコンを設定
            });

            // タグをバッジとして表示
            let tagHtml = '';
            if (tags && tags.length > 0) {
                tags.forEach(tag => {
                    tagHtml += `<span class="badge badge-info">${tag.name}</span> `;
                });
            }

            // インフォウィンドウ
            const contentString = `
                <div class="info-window">
                    <h3>${title}</h3>
                    <p>評価: ${average_rating ? average_rating.toFixed(1) : 'なし'} / 5</p>
                    <p>オプション: ${tagHtml}</p>
                    <a href="/posts/${post.id}" class="btn btn-primary mt-2">詳細を見る</a>
                </div>
            `;

            const infowindow = new google.maps.InfoWindow({
                content: contentString,
            });

            marker.addListener("click", () => {
                infowindow.open({
                    anchor: marker,
                    map,
                    shouldFocus: false,
                });
            });

            markers.push(marker); // 複数のマーカーを管理
        }
    });
}

// 緯度・経度から住所
async function geocodeLatLng(latLng) {
    return new Promise((resolve, reject) => {
        const geocoder = new google.maps.Geocoder();
        geocoder.geocode({ location: latLng, language: 'ja' }, (results, status) => {
            if (status === 'OK') {
                if (results[0]) {
                    const result = results[0];
                    let postalCode = '';
                    let prefecture = '';   // 都道府県
                    let city = '';         // 市区町村
                    let ward = '';         // 区
                    let town = '';         // 町名
                    let street = '';       // 番地

                    // `address_components` から詳細な住所情報を取得
                    result.address_components.forEach(component => {
                        const types = component.types;
                        if (types.includes('postal_code')) {
                            postalCode = component.long_name;
                        } else if (types.includes('administrative_area_level_1')) {
                            prefecture = component.long_name;
                        } else if (types.includes('locality')) {
                            city = component.long_name;
                        } else if (types.includes('administrative_area_level_2')) {
                            ward = component.long_name;
                        } else if (types.includes('sublocality')) {
                            town = component.long_name;
                        } else if (types.includes('route') || types.includes('street_address')) {
                            street += component.long_name;
                        }
                    });

                    // 番地の処理を改善
                    street = street.replace(/([０-９]+)丁目/, '$1丁目');
                    street = street.replace(/([０-９]+)番地?/, '$1番地');
                    street = street.replace(/([０-９]+)号/, '$1号');
                    street = street.replace(/−/g, '-');

                    // 全角数字を半角に変換
                    street = street.replace(/[０-９]/g, function(s) {
                        return String.fromCharCode(s.charCodeAt(0) - 0xFEE0);
                    });

                    // 日本の住所形式に従って住所を組み立てる
                    let address = [prefecture, city, ward, town, street].filter(Boolean).join('');

                    // `formatted_address` から不要な部分を除外
                    const formattedAddress = result.formatted_address || '';
                    const addressWithoutUnwantedParts = formattedAddress
                        .replace(/〒[0-9]{3}-[0-9]{4}\s*/, '') // 郵便番号の削除
                        .replace(/日本\s*/, '') // 「日本」の削除
                        .replace(/、/, '') // コンマ「、」の削除
                        .trim(); // トリムして余分なスペースを削除

                    // 最終的な住所を決定
                    let finalAddress = addressWithoutUnwantedParts || address;

                    resolve({ address: finalAddress, postalCode });
                } else {
                    console.warn('Geocoder found no results');
                    reject('No results found');
                }
            } else {
                console.error('Geocoder failed due to:', status);
                reject(`Geocoder failed due to: ${status}`);
            }
        });
    });
}

// ターボリンクがロードされたときに地図を初期化
document.addEventListener('turbolinks:load', () => {
    const mapElement = document.getElementById('map');
    if (mapElement) {
        initMap();
    }
});