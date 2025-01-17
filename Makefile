build:
	mix site.build

serve:
	cd output && python -m http.server 8000

watch:
	fswatch lib/personal_website.ex | xargs -n1 -I{} mix site.build
