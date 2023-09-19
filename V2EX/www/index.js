$(document).ready(() => {
	const imgUrl = [];

	// 将图片替换成loading图片
	function replaceImg(loading) {
		const imgs = $('img');
		if (imgs.length) {
			console.log('有图片');
			imgs.each(i => {
				const img = imgs[i];
				imgUrl.push(img.src);
				img.src = './image_holder_loading.gif';
			});
			recalculateHeight();
		} else {
			const height = $('body').height();
			sendHeightToSwiftUI(height);
		}
	}
	replaceImg();

	// 加载图片
	function loadImg(src) {
		return new Promise((resolve, reject) => {
			const img = new Image();
			img.onload = () => resolve(true);
			img.onerror = () => resolve(false);
			img.src = src;
		});
	}

	// 根据图片加载结果重新获取dom高度
	async function recalculateHeight() {
		const imgs = $('img');
		const len = imgs.length;
		let index = 0;
		for (let i = 0; i < len; i++) {
			const src = imgUrl[i];
			const res = await loadImg(src);
			if (res) {
				index++;
				imgs[i].src = src;
			} else {
				imgs[i].src = './image_holder_failed.png';
			}
		}
		watchHeightChange();
	}

	// 监听高度变化
	function watchHeightChange() {
		const resizeObserver = new ResizeObserver(entries => {
			const height = entries[0].target.clientHeight;
			sendHeightToSwiftUI(height);
		});
		resizeObserver.observe(document.body);
	}

	// 发送文档高度给Swiftui
	function sendHeightToSwiftUI(height) {
		window.webkit.messageHandlers.getHeight.postMessage(height);
	}
});
