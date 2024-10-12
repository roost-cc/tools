// Select anchors w/o a target
export const selector="a[href], img[src]")

export default async function(node) {
  const fs = await import('fs');
  const path = await import('path');
  const href = node.getAttribute('href')
  // only process anchors that are local
  if (fs.existsSync(path.resolve(href))) {
    node.setAttribute('target','')
  }
}

export const beautify = {
  indent_size: 2,
  html: {
    end_with_newline: false,
    eol: "\n",
    js: {
      indent_size: 2
    },
    css: {
      indent_size: 2
    }
  },
  css: {
    indent_size: 2
  },
  js: {
    "preserve-newlines": true
  }
}
